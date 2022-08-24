import sys
import yaml
import os
import pathlib
import logging
import traceback
from pathlib import Path
global DEBUG
DEBUG = True

try:
    #import colorama
    from colorama import init
    init()
    from colorama import Fore, Back, Style
    COLORMEQUALIFIED = True
except ImportError as derp:
    print("[-] NO COLOR PRINTING FUNCTIONS AVAILABLE, Install the Colorama Package from pip")
    COLORMEQUALIFIED = False

################################################################################
##############               LOGGING AND ERRORS                #################
################################################################################
log_file            = 'logfile'
logging.basicConfig(filename=log_file, 
                    #format='%(asctime)s %(message)s', 
                    filemode='w'
                    )
logger              = logging.getLogger()
launchercwd         = pathlib.Path().absolute()

redprint          = lambda text: print(Fore.RED + ' ' +  text + ' ' + Style.RESET_ALL) if (COLORMEQUALIFIED == True) else print(text)
blueprint         = lambda text: print(Fore.BLUE + ' ' +  text + ' ' + Style.RESET_ALL) if (COLORMEQUALIFIED == True) else print(text)
greenprint        = lambda text: print(Fore.GREEN + ' ' +  text + ' ' + Style.RESET_ALL) if (COLORMEQUALIFIED == True) else print(text)
yellowboldprint = lambda text: print(Fore.YELLOW + Style.BRIGHT + ' {} '.format(text) + Style.RESET_ALL) if (COLORMEQUALIFIED == True) else print(text)
makeyellow        = lambda text: Fore.YELLOW + ' ' +  text + ' ' + Style.RESET_ALL if (COLORMEQUALIFIED == True) else None
makered           = lambda text: Fore.RED + ' ' +  text + ' ' + Style.RESET_ALL if (COLORMEQUALIFIED == True) else None
makegreen         = lambda text: Fore.GREEN + ' ' +  text + ' ' + Style.RESET_ALL if (COLORMEQUALIFIED == True) else None
makeblue          = lambda text: Fore.BLUE + ' ' +  text + ' ' + Style.RESET_ALL if (COLORMEQUALIFIED == True) else None
debugred = lambda text: print(Fore.RED + '[DEBUG] ' +  text + ' ' + Style.RESET_ALL) if (DEBUG == True) else None
debugblue = lambda text: print(Fore.BLUE + '[DEBUG] ' +  text + ' ' + Style.RESET_ALL) if (DEBUG == True) else None
debuggreen = lambda text: print(Fore.GREEN + '[DEBUG] ' +  text + ' ' + Style.RESET_ALL) if (DEBUG == True) else None
debugyellow = lambda text: print(Fore.YELLOW + '[DEBUG] ' +  text + ' ' + Style.RESET_ALL) if (DEBUG == True) else None
debuglog     = lambda message: logger.debug(message) 
infolog      = lambda message: logger.info(message)   
warninglog   = lambda message: logger.warning(message) 
errorlog     = lambda message: logger.error(message) 
criticallog  = lambda message: logger.critical(message)

def file_to_text(filepath:Path):
    '''
    opens a file and returns the text
    '''
    fileobject = open(filepath)
    file_text = fileobject.read()
    fileobject.close()
    return file_text

def get_dirlist(directory:Path)-> list[Path]:
    '''
    Returns a directory listing of BOTH files and folders
    '''
    wat = []
    for filepath in pathlib.Path(directory).iterdir():
        wat.append(Path(filepath))
    return wat


def getsubdirs(directory)->list[Path]:
    '''
    Returns folders in a directory as Path objects
    '''
    wat = []
    for filepath in pathlib.Path(directory).iterdir():
       if (Path(filepath).is_dir()):
           wat.append(Path(filepath))
    return wat

def getsubfiles(directory)->list:
    '''
    Shallow directory listing of files only \n
    for deep search use getsubfiles_deep()
    '''
    wat = []
    for filepath in pathlib.Path(directory).iterdir():
       if (Path(filepath).is_file()):
           wat.append(Path(filepath))
    return wat

def getsubfiles_deep(directory)->list[Path]:
    '''
    Returns ALL sub-files in a directory as Paths\n
    This itterates down to the BOTTOM of the hierarchy!
    This is a highly time intensive task!
    '''
    wat = [Path(filepath) for filepath in pathlib.Path(directory).glob('**/*')]
    return wat


def getsubfiles_dict(directory)->dict[str:Path]:
    '''
    Returns files in a directory as absolute paths in a dict
    {
        1filename : 1filepath,
        2filename : 2filepath,
        3filename : 3filepath,
        ... and so on
    }
    '''
    wat = {}
    #wat = {filepath.stem: Path(filepath) for filepath in pathlib.Path(directory).glob('**/*')}
    #directory_list = Path(directory).glob('**/*')
    for filepath in pathlib.Path(directory).iterdir():
        if filepath.is_file():
            wat[filepath.stem] = filepath.absolute()
    return wat


# open with read operation
yamlbuffer_read = lambda path: open(Path(path),'r')
# open with write operation
yamlbuffer_write = lambda path: open(Path(path),'r')
#loads a challenge.yaml file into a buffer
loadyaml =  lambda category,challenge: yaml.load(yamlbuffer_read(category,challenge), Loader=yaml.FullLoader)
writeyaml =  lambda category,challenge: yaml.dump_all(yamlbuffer_write(category,challenge), Loader=yaml.FullLoader)
# simulation of a chdir command to "walk" through the repo
# helps metally
#location = lambda currentdirectory,childorsibling: Path(currentdirectory,childorsibling)
# gets path of a file
getpath = lambda directoryitem: Path(os.path.abspath(directoryitem))

################################################################################
##############           TERMINAL FILE SYNTAX HIGHLIGHT        #################
################################################################################


from pygments import formatters, highlight, lexers
from pygments.util import ClassNotFound
#from simple_term_menu import TerminalMenu


def highlight_file(filepath):
	with open(filepath, "r") as f:
		file_content = f.read()
	try:
		lexer = lexers.get_lexer_for_filename(filepath,
											  stripnl=False,
											  stripall=False)
	except ClassNotFound:
		lexer = lexers.get_lexer_by_name("text", stripnl=False, stripall=False)
	formatter = formatters.TerminalFormatter(bg="dark")  # dark or light
	highlighted_file_content = highlight(file_content, lexer, formatter)
	return highlighted_file_content


def list_files(directory="."):
	return (file for file in os.listdir(directory) if os.path.isfile(os.path.join(directory, file)))

################################################################################
##############                Environment Handling              ################
################################################################################

def putenv(key,value):
	"""
	Puts an environment variable in place

	For working in the interactive mode when run with
	>>> hacklab.py -- --interactive
	"""
	try:
		os.environ[key] = value
		greenprint(f"[+] {key} Env variable set to {value}")
	except Exception:
		errorlogger(f"[-] Failed to set {key} with {value}")

def check_env():
    '''
    Checks env for existing values before setting
    '''
    raise NotImplemented("[-] Function unavailable currently")

def setenv(**kwargs):
	'''
	sets the environment variables given by **kwargs

	The double asterisk form of **kwargs is used to pass a keyworded,
	variable-length argument dictionary to a function.
	'''
	try:
		if __name__ !="" and len(kwargs) > 0:
			#projectname = __name__
			for key,value in kwargs:
				putenv(key,value)

		else:
			raise Exception
	except Exception:
		errorlogger("""[-] Failed to set environment variables!\n
	this is an extremely important step and the program must exit now. \n
	A log has been created with the information from the error shown,  \n
	please provide this information to the github issue tracker""")
		sys.exit(1)

################################################################################
##############             ERROR HANDLING FUNCTIONS            #################
################################################################################
def errorlogger(message):
    """
    prints line number and traceback
    TODO: save stack trace to error log
            only print linenumber and function failure
    """
    exc_type, exc_value, exc_tb = sys.exc_info()
    trace = traceback.TracebackException(exc_type, exc_value, exc_tb) 
    lineno = 'LINE NUMBER : ' + str(exc_tb.tb_lineno)
    logger.error(
        redprint(
            message+"\n [-] "+lineno+"\n [-] "+''.join(trace.format_exception_only()) +"\n"
            )
        )

"""

class Dockerfile:
    '''
    Python representation of a standard Dockerfile
    '''
    def __new__(cls,*args, **kwargs):
        cls.__name__ = 'Dockerfile'
        cls.__qualname__= cls.__name__
        cls.tag = '!Dockerfile'
        return super(cls).__new__(cls, *args, **kwargs)
    
    def __init__(self,dockerfile_path:Path, **entries): 
        #print("[+] Transforming Dockerfile to python code")
        self.__dict__.update(entries)
        self.dockerfile_path = dockerfile_path
    
    def __repr__(self):
        '''
        '''
        wat = []
        for key in self.__dict__:
            wat.append(str(key) + " : " + str(self.__dict__[key]))
        #return self_repr
        return wat
    
    def get_text(self):
        self.__repr__()

    def to_yaml(self, pyyaml=False):
        '''
        Converts class to yaml, use "pyaml=true" to store as python code objects
        '''
        if pyyaml == False:
            raise NotImplemented
        elif pyyaml == True:
            raise NotImplemented
            #not functional yet
            #Constructor._writeyaml()


class SpecFile(yaml):
    '''
    Metaclass for loading yml files into
    '''
    def __new__(cls,*args, **kwargs):
        cls.__name__ = 'service'
        cls.__qualname__= cls.__name__
        cls.tag = '!service'
        return super(cls).__new__(cls, *args, **kwargs)
    
    def __init__(self,**entries): 
        print("[+] Creating Service.yaml python code")
        self.__dict__.update(entries)
    
    def __repr__(self):
        '''
        '''
        wat = []
        for key in self.__dict__:
            wat.append(str(key) + " : " + str(self.__dict__[key]))
        #return self_repr
        return wat

class KubernetesYaml(SpecFile): #file
    '''
    Represents a Kubernetes specification
    future
    '''    
    def __init__(self): 
        print("[+] Generating new repository")


class HelmManagment():
    def __init__(self):
        '''
        Uses pyhelm to provision the kubernetes infrastructure
        '''
"""