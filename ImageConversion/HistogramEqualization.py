import subprocess
import sys
import os
import ImageConverter
import ImageReader
import time

def histogramEqualization(imagePath):

    os.remove("./image.txt")
    finalSize = ImageConverter.getBytesFromFile(imagePath)
    print("Image Converter to bytes...")
    os.remove("../AssemblyCode/imageHE.txt")
    open("../AssemblyCode/imageHE.txt", 'w')
    subprocess.Popen(["make"], stdout=subprocess.PIPE, cwd="../AssemblyCode")
    print("Image processing Please wait...")
    time.sleep(15)
    print("Image processed...")
    print("Opening image...")
    deleteLastLine("../AssemblyCode/imageHE.txt")
    ImageReader.imageReader(imagePath, finalSize)

def deleteLastLine(path):
    readFile = open(path)
    lines = readFile.readlines()
    readFile.close()
    w = open(path, 'w')
    lastItem = str(lines[-1])
    lines[-1] = str(int(lastItem))
    w.writelines([item for item in lines])
    w.close()


histogramEqualization(sys.argv[1])