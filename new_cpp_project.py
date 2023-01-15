import shutil
import os
import subprocess
import sys

if not os.path.exists("cpp-project-template"):
    os.chdir("..")

    if not os.path.exists("cpp-project-template"):
        print("cpp-project-template folder not found either in this or parent folder")
        sys.exit()

print("What is your project name?")
destination_name = input()

if os.path.exists(destination_name):
    print("Project with the same name already exists :'(")
    sys.exit()

shutil.copytree("cpp-project-template", destination_name)

delete_list = [ ".git", "README.md" ]

os.chdir(destination_name)

def onerror(func, path, exc_info):
    import stat
    # Is the error an access error?
    if not os.access(path, os.W_OK):
        os.chmod(path, stat.S_IWUSR)
        func(path)
    else:
        raise

shutil.rmtree(".git", onerror=onerror)
os.remove("README.md")
print("Removed .git and README.md")

subprocess.call(["premake5", "vs2022"])

print("Make git repo? (y/n)")

if input() == "y":
    subprocess.call(["git", "init"])
    subprocess.call(["git", "add", "."])
    subprocess.call(["git", "commit", "-m", "Initial"])

print("Open VS? (y/n)")

if input() == "y":
    sln = destination_name + ".sln"
    subprocess.Popen(["start", sln], shell=True)