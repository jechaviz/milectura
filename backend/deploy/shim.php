<?php
declare(strict_types=1);

/**
 * Mi Lectura Diaria — minimal PHP shim (the ONLY PHP in the request path),
 * modeled on realstate/electroprice vbackend/shim.php. Holds NO application
 * logic: it execs the single native V-compiled binary (CGI mode) and relays
 * its response.
 *
 * Deployed footprint on Spaceship cPanel under appniverse.com/milectura:
 *   - this shim.php + .htaccess + the static SPA files (in the docroot sub-path)
 *   - milectura        (one native binary, OUTSIDE the docroot)
 *   - modules/*.SQLite3 (read-only MyBible modules, OUTSIDE the docroot)
 */

// --- paths (Spaceship account: agingriouh; site: appniverse.com/milectura) --
const ML_BIN     = '/home/agingriouh/apps/milectura/shared/bin/milectura';
const ML_MODULES = '/home/agingriouh/apps/milectura/shared/modules';
const ML_BASE    = '/milectura';

function fail(int $code, string $message): void {
    http_response_code($code);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode(['error' => $message]);
    exit;
}

if (!is_executable(ML_BIN)) {
    fail(500, 'Backend no disponible.');
}

// Build the binary's environment: CGI vars + app config.
$env = [];
foreach ($_SERVER as $k => $v) {
    if (is_string($v)) {
        $env[$k] = $v;
    }
}
$env['GATEWAY_INTERFACE'] = $env['GATEWAY_INTERFACE'] ?? 'CGI/1.1';
$env['ML_MODULES']   = ML_MODULES;
$env['ML_BASE_PATH'] = ML_BASE;

$descriptors = [0 => ['pipe', 'r'], 1 => ['pipe', 'w'], 2 => ['pipe', 'w']];
$process = proc_open(ML_BIN, $descriptors, $pipes, null, $env);
if (!is_resource($process)) {
    fail(502, 'No se pudo iniciar el backend.');
}

// This API is read-only (GET); still relay any body for completeness.
$reqBody = file_get_contents('php://input');
if ($reqBody !== false && $reqBody !== '') {
    fwrite($pipes[0], $reqBody);
}
fclose($pipes[0]);
$out = stream_get_contents($pipes[1]) ?: '';
fclose($pipes[1]);
$err = stream_get_contents($pipes[2]) ?: '';
fclose($pipes[2]);
$status = proc_close($process);

if ($status !== 0 && $out === '') {
    fail(502, 'Error del backend: ' . substr($err, 0, 300));
}

// Split CGI headers from body and re-emit them.
$split = preg_split("/\r\n\r\n|\n\n/", $out, 2);
if (count($split) === 2) {
    foreach (preg_split("/\r\n|\n/", $split[0]) as $line) {
        if ($line === '') {
            continue;
        }
        if (stripos($line, 'Status:') === 0) {
            http_response_code((int) trim(substr($line, 7)));
            continue;
        }
        header($line, false);
    }
    echo $split[1];
} else {
    header('Content-Type: application/json; charset=utf-8');
    echo $out;
}
