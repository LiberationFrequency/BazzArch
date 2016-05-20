# calibre wide preferences

### Begin group: DEFAULT
 
# database path
# Pfad zur Datenbank, in der die Bücher gespeichtert sind
database_path = '/home/live-user/library1.db'
 
# filename pattern
# Verhaltensmuster zum Ermitteln der Metadaten aus den Dateinamen
filename_pattern = u'(?P<title>.+) - (?P<author>[^_]+)'
 
# isbndb com key
# Zugangsschlüssel für isbndb.com
isbndb_com_key = ''
 
# network timeout
# Standardeinstellung der Zeitüberschreitung bei Netzwerkverbindungen (in Sekunden)
network_timeout = 5
 
# library path
# Pfad zum Verzeichnis, in dem die Buchbibliothek gespeichert ist
library_path = u'/home/live-user/Calibre-Bibliothek'
 
# language
# Sprache, in der die Benutzeroberfläche dargestellt wird
language = 'de'
 
# output format
# Standardzielformat für eBook-Konvertierungen.
output_format = 'epub'
 
# input format order
# Geordnete Liste der Formate, die bei der Eingabe bevorzugt werden.
input_format_order = cPickle.loads('\x80\x02]q\x01(U\x04EPUBq\x02U\x04AZW3q\x03U\x04MOBIq\x04U\x03LITq\x05U\x03PRCq\x06U\x03FB2q\x07U\x04HTMLq\x08U\x03HTMq\tU\x04XHTMq\nU\x05SHTMLq\x0bU\x05XHTMLq\x0cU\x03ZIPq\rU\x04DOCXq\x0eU\x03ODTq\x0fU\x03RTFq\x10U\x03PDFq\x11U\x03TXTq\x12e.')
 
# read file metadata
# Metadaten aus Dateien lesen
read_file_metadata = True
 
# worker process priority
# Die Priorität des Arbeitsprozesses. Eine höhere Priorität bedeutet ein schnelleres Arbeiten, verbraucht aber mehr Ressourcen. Die meisten Aufgaben wie Konvertierungen/News herunteraden/Bücher hinzufügen/etc. werden von dieser Einstellung beeinflusst.
worker_process_priority = 'normal'
 
# swap author names
# Vorname und Nachname des Autors beim Einlesen der Metadaten vertauschen
swap_author_names = False
 
# add formats to existing
# Neue Formate zu schon vorhandenen Bucheinträgen hinzufügen
add_formats_to_existing = False
 
# check for dupes on ctl
# Beim Kopieren in eine andere Bibliothek auf Duplikate prüfen
check_for_dupes_on_ctl = False
 
# installation uuid
# Installation UUID
installation_uuid = 'af2b9c05-52db-49ad-a494-1e350310da0b'
 
# new book tags
# Schlagwörter, die neu hinzugefügten Büchern angehängt werden sollen
new_book_tags = cPickle.loads('\x80\x02]q\x01.')
 
# mark new books
# Neu hinzugefügte Bücher markieren. Diese Markierung ist temporär und wird nach dem Neustart von Calibre automatisch entfernt.
mark_new_books = False
 
# saved searches
# Liste der benannten gespeicherten Suchen
saved_searches = cPickle.loads('\x80\x02}q\x01.')
 
# user categories
# Vom Benutzer erstellte Schlagwortbrowser-Kategorien
user_categories = cPickle.loads('\x80\x02}q\x01.')
 
# manage device metadata
# Wie und wann Calibre Metadaten auf dem Gerät aktualisiert.
manage_device_metadata = 'manual'
 
# limit search columns
# Wenn Sie ohne Suchpräferenzen suchen, wie zum Beispiel "rot" statt "title:rot", werden die durchsuchten Spalten auf die unten angezeigten eingegrenzt.
limit_search_columns = False
 
# limit search columns to
# Spalten auswählen, die beim Weglassen von Präfixen durchsucht werden sollen, z. B. bei der Suche nach "rot" anstatt nach "title:rot". Geben Sie eine kommagetrennte Liste von Suchnamen ein. Nur wirksam, wenn Sie oben die Option zur Begrenzung von Suchspalten aktivieren.
limit_search_columns_to = cPickle.loads('\x80\x02]q\x01(U\x05titleq\x02U\x07authorsq\x03U\x04tagsq\x04U\x06seriesq\x05U\tpublisherq\x06e.')
 
# use primary find in search
# Characters typed in the search box will match their accented versions, based on the language you have chosen for the calibre interface. For example, in  English, searching for n will match ñ and n, but if your language is Spanish it will only match n. Note that this is much slower than a simple search on very large libraries.
use_primary_find_in_search = True
 
# migrated
# For Internal use. Don't modify.
migrated = False
 


