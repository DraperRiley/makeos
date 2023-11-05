bits 16

%ifndef HEADERS
	%define HEADERS

	; FAT 12 STUFF
	jmp short start
	nop
	
	bdb_oem: 	           db 'MSWIN4.1'
	bdb_bytes_per_sector: 	   dw 512
	bdb_sectors_per_cluster:   db 1
	bdb_reserved_sectors:      dw 1
	bdb_fat_count:             db 2
	bdb_dir_entries_count:     dw 0x0E0
	bdb_total_sectors:         dw 2880
	bdb_media_descriptor_type: db 0x0F0
	bdb_sectors_per_fat:       dw 9
	bdb_sectors_per_track:     dw 18
	bdb_heads:                 dw 2
	bdb_hidden_sectors:        dd 0
	bdd_large_sector_count:    dd 0
	
	ebr_drive_number:          db 0
			           db 0
	
	ebr_signature:             db 0x29
	ebr_volume_id:             db 0x12, 0x34, 0x56, 0x78
	ebr_volume_label:          db 'OSTEST     '
	ebr_system_id:             db 'FAT12   '

%endif
