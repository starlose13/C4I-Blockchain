/*//////////////////////////////////////////////////////////////
                               imports
    //////////////////////////////////////////////////////////////*/
import { existsSync, mkdirSync, readdir, copyFile } from 'fs';
import { resolve, extname, join, dirname } from 'path';
import { fileURLToPath } from 'url';


/*//////////////////////////////////////////////////////////////
                Convert import.meta.url to a file path
    //////////////////////////////////////////////////////////////*/
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);



/*//////////////////////////////////////////////////////////////
            Define the source and destination directories
    //////////////////////////////////////////////////////////////*/
const sourceDir = resolve(__dirname, '../out/ConsensusMechanism.sol');  // Adjust the path to your out directory
const destDir = resolve(__dirname, '../src/utils/ConsensusMechanismABI');  // Copy ABI files to the public/abi directory

/*//////////////////////////////////////////////////////////////
                       Log paths for debugging
    //////////////////////////////////////////////////////////////*/
console.log('Source Directory:', sourceDir);
console.log('Destination Directory:', destDir);

/*//////////////////////////////////////////////////////////////
               Ensure the destination directory exists
    //////////////////////////////////////////////////////////////*/
if (!existsSync(destDir)) {
    mkdirSync(destDir, { recursive: true });
}


/*//////////////////////////////////////////////////////////////
          Copy all ABI JSON files from source to destination
    //////////////////////////////////////////////////////////////*/
readdir(sourceDir, (err, files) => {
    if (err) {
        console.error(`Error reading directory: ${err.message}`);
        return;
    }

    files.forEach(file => {
        if (extname(file) === '.json') {
            const sourceFile = join(sourceDir, file);
            const destFile = join(destDir, file);

            copyFile(sourceFile, destFile, (err) => {
                if (err) {
                    console.error(`Error copying file: ${err.message}`);
                } else {
                    console.log(`Copied ${file} to ${destDir}`);
                }
            });
        }
    });
});
