module main

// ---------------------------------------------------------------------------
// Versículo del día: curated list of promises/classics, cycled by day of year.
// Book numbers follow the MyBible numbering used by the ph4.org modules
// (Est=190, Job=220, Sal=230, Pr=240, ..., Mt=470 ... Ap=730).
// Deterministic: same date -> same verse, no network, works offline.
// ---------------------------------------------------------------------------

struct VotdRef {
	b  int
	c  int
	v1 int
	v2 int
}

const votd_list = [
	VotdRef{500, 3, 16, 16}, // Juan 3:16
	VotdRef{230, 23, 1, 3}, // Salmos 23:1-3
	VotdRef{300, 29, 11, 11}, // Jeremías 29:11
	VotdRef{520, 8, 28, 28}, // Romanos 8:28
	VotdRef{570, 4, 13, 13}, // Filipenses 4:13
	VotdRef{240, 3, 5, 6}, // Proverbios 3:5-6
	VotdRef{290, 41, 10, 10}, // Isaías 41:10
	VotdRef{230, 46, 1, 3}, // Salmos 46:1-3
	VotdRef{470, 11, 28, 30}, // Mateo 11:28-30
	VotdRef{60, 1, 9, 9}, // Josué 1:9
	VotdRef{520, 8, 38, 39}, // Romanos 8:38-39
	VotdRef{430, 3, 17, 17}, // Sofonías 3:17
	VotdRef{230, 27, 1, 1}, // Salmos 27:1
	VotdRef{620, 1, 7, 7}, // 2 Timoteo 1:7
	VotdRef{290, 40, 31, 31}, // Isaías 40:31
	VotdRef{230, 119, 105, 105}, // Salmos 119:105
	VotdRef{500, 14, 6, 6}, // Juan 14:6
	VotdRef{530, 13, 4, 7}, // 1 Corintios 13:4-7
	VotdRef{550, 5, 22, 23}, // Gálatas 5:22-23
	VotdRef{650, 11, 1, 1}, // Hebreos 11:1
	VotdRef{230, 37, 4, 5}, // Salmos 37:4-5
	VotdRef{470, 6, 33, 33}, // Mateo 6:33
	VotdRef{560, 2, 8, 9}, // Efesios 2:8-9
	VotdRef{230, 91, 1, 2}, // Salmos 91:1-2
	VotdRef{290, 26, 3, 3}, // Isaías 26:3
	VotdRef{500, 16, 33, 33}, // Juan 16:33
	VotdRef{670, 5, 7, 7}, // 1 Pedro 5:7
	VotdRef{660, 1, 5, 5}, // Santiago 1:5
	VotdRef{230, 34, 8, 8}, // Salmos 34:8
	VotdRef{400, 6, 8, 8}, // Miqueas 6:8
	VotdRef{310, 3, 22, 23}, // Lamentaciones 3:22-23
	VotdRef{520, 12, 2, 2}, // Romanos 12:2
	VotdRef{580, 3, 23, 24}, // Colosenses 3:23-24
	VotdRef{230, 118, 24, 24}, // Salmos 118:24
	VotdRef{470, 5, 16, 16}, // Mateo 5:16
	VotdRef{500, 15, 5, 5}, // Juan 15:5
	VotdRef{540, 5, 17, 17}, // 2 Corintios 5:17
	VotdRef{230, 121, 1, 2}, // Salmos 121:1-2
	VotdRef{240, 18, 10, 10}, // Proverbios 18:10
	VotdRef{290, 53, 5, 5}, // Isaías 53:5
	VotdRef{520, 5, 8, 8}, // Romanos 5:8
	VotdRef{690, 1, 9, 9}, // 1 Juan 1:9
	VotdRef{230, 19, 14, 14}, // Salmos 19:14
	VotdRef{650, 4, 16, 16}, // Hebreos 4:16
	VotdRef{50, 31, 6, 6}, // Deuteronomio 31:6
	VotdRef{230, 139, 14, 14}, // Salmos 139:14
	VotdRef{410, 1, 7, 7}, // Nahúm 1:7
	VotdRef{500, 1, 1, 5}, // Juan 1:1-5
	VotdRef{730, 21, 4, 4}, // Apocalipsis 21:4
	VotdRef{230, 100, 4, 5}, // Salmos 100:4-5
	VotdRef{560, 3, 20, 21}, // Efesios 3:20-21
	VotdRef{520, 15, 13, 13}, // Romanos 15:13
	VotdRef{10, 1, 1, 1}, // Génesis 1:1
	VotdRef{230, 51, 10, 12}, // Salmos 51:10-12
	VotdRef{470, 28, 19, 20}, // Mateo 28:19-20
	VotdRef{510, 1, 8, 8}, // Hechos 1:8
	VotdRef{140, 7, 14, 14}, // 2 Crónicas 7:14
	VotdRef{500, 10, 10, 10}, // Juan 10:10
	VotdRef{230, 55, 22, 22}, // Salmos 55:22
	VotdRef{290, 55, 8, 9}, // Isaías 55:8-9
	VotdRef{590, 5, 16, 18}, // 1 Tesalonicenses 5:16-18
	VotdRef{650, 12, 1, 2}, // Hebreos 12:1-2
	VotdRef{230, 30, 5, 5}, // Salmos 30:5
	VotdRef{240, 16, 3, 3}, // Proverbios 16:3
	VotdRef{500, 8, 12, 12}, // Juan 8:12
	VotdRef{520, 10, 9, 10}, // Romanos 10:9-10
	VotdRef{560, 6, 10, 11}, // Efesios 6:10-11
	VotdRef{230, 62, 1, 2}, // Salmos 62:1-2
	VotdRef{470, 7, 7, 8}, // Mateo 7:7-8
	VotdRef{300, 33, 3, 3}, // Jeremías 33:3
	VotdRef{580, 3, 15, 15}, // Colosenses 3:15
	VotdRef{530, 10, 13, 13}, // 1 Corintios 10:13
	VotdRef{230, 103, 2, 4}, // Salmos 103:2-4
	VotdRef{290, 43, 2, 2}, // Isaías 43:2
	VotdRef{500, 14, 27, 27}, // Juan 14:27
	VotdRef{520, 6, 23, 23}, // Romanos 6:23
	VotdRef{550, 2, 20, 20}, // Gálatas 2:20
	VotdRef{230, 16, 8, 8}, // Salmos 16:8
	VotdRef{470, 5, 14, 14}, // Mateo 5:14
	VotdRef{650, 13, 8, 8}, // Hebreos 13:8
	VotdRef{660, 4, 8, 8}, // Santiago 4:8
	VotdRef{230, 42, 1, 2}, // Salmos 42:1-2
	VotdRef{240, 4, 23, 23}, // Proverbios 4:23
	VotdRef{500, 11, 25, 26}, // Juan 11:25-26
	VotdRef{540, 12, 9, 9}, // 2 Corintios 12:9
	VotdRef{560, 4, 32, 32}, // Efesios 4:32
	VotdRef{230, 32, 8, 8}, // Salmos 32:8
	VotdRef{290, 9, 6, 6}, // Isaías 9:6
	VotdRef{490, 6, 31, 31}, // Lucas 6:31
	VotdRef{520, 12, 12, 12}, // Romanos 12:12
	VotdRef{670, 2, 9, 9}, // 1 Pedro 2:9
	VotdRef{230, 8, 3, 4}, // Salmos 8:3-4
	VotdRef{470, 22, 37, 39}, // Mateo 22:37-39
	VotdRef{500, 13, 34, 35}, // Juan 13:34-35
	VotdRef{570, 4, 6, 7}, // Filipenses 4:6-7
	VotdRef{230, 145, 18, 19}, // Salmos 145:18-19
	VotdRef{240, 22, 6, 6}, // Proverbios 22:6
	VotdRef{290, 61, 1, 1}, // Isaías 61:1
	VotdRef{520, 8, 1, 1}, // Romanos 8:1
	VotdRef{650, 10, 23, 23}, // Hebreos 10:23
	VotdRef{230, 84, 11, 11}, // Salmos 84:11
	VotdRef{470, 6, 25, 26}, // Mateo 6:25-26
	VotdRef{500, 4, 13, 14}, // Juan 4:13-14
	VotdRef{620, 3, 16, 17}, // 2 Timoteo 3:16-17
	VotdRef{230, 133, 1, 1}, // Salmos 133:1
	VotdRef{250, 3, 1, 1}, // Eclesiastés 3:1
	VotdRef{450, 4, 6, 6}, // Zacarías 4:6
	VotdRef{490, 1, 37, 37}, // Lucas 1:37
	VotdRef{690, 4, 19, 19}, // 1 Juan 4:19
	VotdRef{230, 25, 4, 5}, // Salmos 25:4-5
	VotdRef{240, 27, 17, 17}, // Proverbios 27:17
	VotdRef{290, 12, 2, 2}, // Isaías 12:2
	VotdRef{520, 1, 16, 16}, // Romanos 1:16
	VotdRef{560, 5, 1, 2}, // Efesios 5:1-2
	VotdRef{230, 40, 1, 3}, // Salmos 40:1-3
	VotdRef{470, 5, 6, 6}, // Mateo 5:6
	VotdRef{500, 6, 35, 35}, // Juan 6:35
	VotdRef{580, 2, 6, 7}, // Colosenses 2:6-7
	VotdRef{230, 71, 5, 5}, // Salmos 71:5
	VotdRef{720, 1, 24, 25}, // Judas 24-25
	VotdRef{730, 3, 20, 20}, // Apocalipsis 3:20
	VotdRef{10, 28, 15, 15}, // Génesis 28:15
	VotdRef{230, 34, 18, 18}, // Salmos 34:18
	VotdRef{350, 6, 3, 3}, // Oseas 6:3
	VotdRef{530, 15, 58, 58}, // 1 Corintios 15:58
	VotdRef{50, 6, 5, 5}, // Deuteronomio 6:5
	VotdRef{500, 20, 29, 29}, // Juan 20:29
	VotdRef{230, 90, 12, 12}, // Salmos 90:12
	VotdRef{420, 3, 17, 18}, // Habacuc 3:17-18
	VotdRef{520, 8, 31, 31}, // Romanos 8:31
	VotdRef{650, 6, 19, 19}, // Hebreos 6:19
	VotdRef{470, 19, 26, 26}, // Mateo 19:26
	VotdRef{230, 130, 5, 5}, // Salmos 130:5
]

fn votd_for_day(day int) VotdRef {
	mut d := day
	if d < 1 {
		d = 1
	}
	return votd_list[(d - 1) % votd_list.len]
}
