# preferences for the calibre GUI

### Begin group: DEFAULT
 
# send to storage card by default
# Datei auf die Speicherkarte anstatt in den Hauptspeicher des Gerätes (Voreinstellung) senden
send_to_storage_card_by_default = False
 
# confirm delete
# Bestätigung vor dem Löschen
confirm_delete = False
 
# main window geometry
# Aufteilung des Hauptfensters
main_window_geometry = cPickle.loads("\x80\x02csip\n_unpickle_type\nq\x01U\x0cPyQt5.QtCoreq\x02U\nQByteArrayU2\x01\xd9\xd0\xcb\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x05U\x00\x00\x02\xdf\x00\x00\x00[\x00\x00\x00E\x00\x00\x04\xdc\x00\x00\x02'\x00\x00\x00\x00\x02\x00\x00\x00\x05V\x85\x87Rq\x03.")
 
# new version notification
# Benachrichtigen, wenn neue Version verfügbar
new_version_notification = True
 
# use roman numerals for series number
# Römische Ziffern für Seriennummerierung verwenden
use_roman_numerals_for_series_number = True
 
# sort tags by
# Schlagwörter sortieren nach Name, Beliebtheit oder Bewertung
sort_tags_by = 'name'
 
# match tags type
# Schlagwörter abgleichen nach einem oder allen Wörtern.
match_tags_type = 'any'
 
# cover flow queue length
# Anzahl der Titelbilder, die im Titelbildbrowser angezeigt werden
cover_flow_queue_length = 6
 
# LRF conversion defaults
# Voreinstellungen für Konvertierung zu LRF
LRF_conversion_defaults = cPickle.loads('\x80\x02]q\x01.')
 
# LRF ebook viewer options
# Optionen für den LRF-eBook-Betrachter
LRF_ebook_viewer_options = None
 
# internally viewed formats
# Formate, die mit dem internen Betrachter angezeigt werden
internally_viewed_formats = cPickle.loads('\x80\x02]q\x01(U\x03LRFq\x02U\x04EPUBq\x03U\x03LITq\x04U\x04MOBIq\x05U\x03PRCq\x06U\x04POBIq\x07U\x03AZWq\x08U\x04AZW3q\tU\x04HTMLq\nU\x03FB2q\x0bU\x03PDBq\x0cU\x02RBq\rU\x03SNBq\x0eU\x05HTMLZq\x0fU\x05KEPUBq\x10e.')
 
# column map
# Spalten, die in der Bücherliste angezeigt werden sollen
column_map = cPickle.loads('\x80\x02]q\x01(U\x05titleq\x02U\x08ondeviceq\x03U\x07authorsq\x04U\x04sizeq\x05U\ttimestampq\x06U\x06ratingq\x07U\tpublisherq\x08U\x04tagsq\tU\x06seriesq\nU\x07pubdateq\x0be.')
 
# autolaunch server
# Inhalteserver automatisch beim Aufrufen von Calibre starten
autolaunch_server = False
 
# oldest news
# Älteste in der Datenbank gespeicherte Nachrichten
oldest_news = 60
 
# systray icon
# Infobereichssymbol anzeigen
systray_icon = False
 
# upload news to device
# Geladene Nachrichten auf das Gerät übertragen
upload_news_to_device = True
 
# delete news from library on upload
# Nachrichten/Bücher nach Hochladen auf das Gerät aus der Bibliothek löschen
delete_news_from_library_on_upload = False
 
# separate cover flow
# Titelbildbrowser in eigenem Fenster anzeigen anstatt im Calibre-Hauptfenster
separate_cover_flow = False
 
# disable tray notification
# Infobereichsmitteilungen deaktivieren
disable_tray_notification = False
 
# default send to device action
# Standardaktion beim Anklicken der Schaltfläche "An Gerät senden"
default_send_to_device_action = 'DeviceAction:main::False:False'
 
# asked library thing password
# Asked library thing password at least once.
asked_library_thing_password = False
 
# search as you type
# Start der Suche bei Eingabe. Falls ausgeschaltet, wird die Suche erst angewendet, wenn die Enter- oder Return-Taste gedrückt wird.
search_as_you_type = False
 
# highlight search matches
# Beim Suchen alle Bücher mit hervorgehobenen Suchergebnissen anstatt nur die Übereinstimmungen anzeigen. Sie können die N- oder F3-Tasten verwenden, um zur nächsten Übereinstimmung zu gelangen.
highlight_search_matches = False
 
# save to disk template history
# Previously used Save to Disk templates
save_to_disk_template_history = cPickle.loads('\x80\x02]q\x01.')
 
# send to device template history
# Previously used Send to Device templates
send_to_device_template_history = cPickle.loads('\x80\x02]q\x01.')
 
# main search history
# Search history for the main GUI
main_search_history = cPickle.loads('\x80\x02]q\x01.')
 
# viewer search history
# Search history for the ebook viewer
viewer_search_history = cPickle.loads('\x80\x02]q\x01.')
 
# viewer toc search history
# Search history for the ToC in the ebook viewer
viewer_toc_search_history = cPickle.loads('\x80\x02]q\x01.')
 
# lrf viewer search history
# Search history for the LRF viewer
lrf_viewer_search_history = cPickle.loads('\x80\x02]q\x01.')
 
# scheduler search history
# Search history for the recipe scheduler
scheduler_search_history = cPickle.loads('\x80\x02]q\x01.')
 
# plugin search history
# Search history for the plugin preferences
plugin_search_history = cPickle.loads('\x80\x02]q\x01.')
 
# shortcuts search history
# Search history for the keyboard preferences
shortcuts_search_history = cPickle.loads('\x80\x02]q\x01.')
 
# jobs search history
# Search history for the tweaks preferences
jobs_search_history = cPickle.loads('\x80\x02]q\x01.')
 
# tweaks search history
# Search history for tweaks
tweaks_search_history = cPickle.loads('\x80\x02]q\x01.')
 
# worker limit
# Maximale Anzahl von parallelen Aufträgen für Konvertierungen und Nachrichten-Downloads. Diese Anzahl ist aus historischen Gründen das Doppelte des tatsächlichen Wertes.
worker_limit = 6
 
# get social metadata
# Öffentliche Metadaten herunterladen (Schlagwörtern, Bewertungen usw.)
get_social_metadata = True
 
# overwrite author title metadata
# Autor und Titel mit neuen Metadaten überschreiben
overwrite_author_title_metadata = True
 
# auto download cover
# Titelbilder automatisch herunterladen, falls verfügbar
auto_download_cover = False
 
# enforce cpu limit
# Maximale Anzahl paralleler Aufträge auf Anzahl der CPUs beschränken
enforce_cpu_limit = True
 
# gui layout
# Das Layout der Benutzeroberfläche.  Bei "Breit" befindet sich der Buchdetailsbereich rechts und bei "Schmal" unten.
gui_layout = 'wide'
 
# show avg rating
# Durchschnittliche Bewertung je Eintrag im Schlagwortbrowser anzeigen
show_avg_rating = True
 
# disable animations
# Keine Benutzeroberflächen-Animationen
disable_animations = False
 
# tag browser hidden categories
# Nicht anzuzeigende Schlagwortbrowser-Kategorien
tag_browser_hidden_categories = cPickle.loads('\x80\x02c__builtin__\nset\nq\x01]\x85Rq\x02.')
 


