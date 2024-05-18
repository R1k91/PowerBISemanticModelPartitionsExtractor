//needed to write output on the filesystem
using System.IO; 

string baseFilePath = @"C:\temp\TEscript\output\" + Model.Database.ToString() + @"\"; //where to store the output
string mFile;
string mScript;

//wreate the output directory if it doesn't exist
if (!Directory.Exists(baseFilePath))
{
    Directory.CreateDirectory(baseFilePath);
}

var tables = Model.Tables; //loads all tables from the model
//tables.Output(); //uncomment to see the content of tables

foreach(var t in tables)
{
    //for each table extract the query of the first partition
    mScript = t.Partitions[0].Query;

    //save query into a file
    mFile = baseFilePath + t.Name.Replace("/", "") + ".m"; //optional step done to remove not allowed characters from filename
    using (StreamWriter outputFile = new StreamWriter(mFile))
    {
        outputFile.WriteLine(mScript);
    }
}
