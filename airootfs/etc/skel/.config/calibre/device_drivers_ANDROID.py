# Einstellungen für Gerätetreiber

### Begin group: DEFAULT
 
# format map
# Geordnete Liste der Formate, die das Gerät akzeptiert
format_map = cPickle.loads('\x80\x02]q\x01(U\x04epubq\x02U\x03pdfq\x03e.')
 
# use subdirs
# Dateien in Unterverzeichnissen speichern soweit das Gerät dies unterstützt
use_subdirs = True
 
# read metadata
# Metadaten aus Dateien auf Gerät lesen
read_metadata = True
 
# use author sort
# Autorensortierung anstatt Autor verwenden
use_author_sort = False
 
# save template
# Vorlage zur Steuerung des Speicherns von Büchern
save_template = '{author_sort}/{title} - {authors}'
 
# extra customization
# Zusätzliche Anpassung
extra_customization = cPickle.loads('\x80\x02]q\x01(U?eBooks/import, wordplayer/calibretransfer, Books, sdcard/ebooksq\x02U\x00e.')
 


