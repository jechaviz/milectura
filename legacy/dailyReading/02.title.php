<?php
$versions=['LBLA','DHH','JBS','NBLH','NBV','NTV','PDT','BLPH','RVA-2015','RVC','RVR1960','RVA','SRV-BRG','TLA'];
						
$versionsText=['La Biblia de las Américas (LBLA)','Dios Habla Hoy (DHH)','Jubilee Bible 2000 (Spanish) (JBS)','Nueva Biblia Latinoamericana de Hoy (NBLH)','Nueva Biblia Viva (NBV)','Nueva Traducción Viviente (NTV)','Palabra de Dios para Todos (PDT)','La Palabra (Hispanoamérica) (BLPH)','Reina Valera Actualizada (RVA-2015)','Reina Valera Contemporánea (RVC)','Reina-Valera 1960 (RVR1960)','Reina-Valera Antigua (RVA)','Spanish Blue Red and Gold Letter Edition (SRV-BRG)','Traducción en lenguaje actual (TLA)'];
?>
<section id="dropdown-menu-2btn-8">
   <nav class="navbar navbar-dropdown bg-color transparent navbar-fixed-top">
      <div class="container">
         <div class="navbar-brand">
            <a href="index.html" class="navbar-logo"><img src="<?php echo $logoUrl;?>" alt="biblia"></a> 
            <a class="text-white" href="index.html"><?php echo $title;?></a>
         </div>
         <button class="navbar-toggler pull-xs-right hidden-md-up" type="button" data-toggle="collapse" data-target="#exCollapsingNavbar">☰</button>
         <ul class="nav-dropdown collapse pull-xs-right navbar-toggleable-sm nav navbar-nav" id="exCollapsingNavbar">
            <li class="nav-item dropdown">
               <a class="nav-link link dropdown-toggle text-white" data-toggle="dropdown-submenu" href="#" aria-expanded="false">Version</a>
               <div class="dropdown-menu">
				<?php 
					for($v=0;$v<sizeof($versions);$v++){
						echo ('<a class="dropdown-item text-white" href="/'.$versions[$v].'/'.$year.'/'.$month.'/'.$day.'">'.$versionsText[$v].'</a>');
					}
				?>
               </div>
            </li>
			<li class="nav-item">
				<a class="nav-link link text-white" href="#nt"><?php echo $ntReadingTitle;?></a>
			</li>
			<li class="nav-item">
				<a class="nav-link link text-white" href="#ot"><?php echo $atReadingTitle;?></a>
			</li>
         </ul>
      </div>
   </nav>
</section>