/*//////////////////////////////////////////////////////////////
                               imports
    //////////////////////////////////////////////////////////////*/
import { existsSync, mkdirSync, readdir, readFile, writeFile, stat } from 'fs';
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
const sourceDir = resolve(__dirname, '../out/NodeManager.sol');  // Adjust the path to your out directory
const destDir = resolve(__dirname, '../src/utils/NodeManagerABI');  // Copy ABI files to the public/abi directory

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
const processFiles = (srcDir, destDir) => {
    readdir(srcDir, (err, files) => {
        if (err) {
            console.error(`Error reading directory: ${err.message}`);
            return;
        }

        files.forEach(file => {
            const srcFile = join(srcDir, file);
            const destFile = join(destDir, file);

            stat(srcFile, (err, stats) => {
                if (err) {
                    console.error(`Error stating file: ${err.message}`);
                    return;
                }

                if (stats.isDirectory()) {
                    if (!existsSync(destFile)) {
                        mkdirSync(destFile, { recursive: true });
                    }
                    processFiles(srcFile, destFile);
                } else if (extname(file) === '.json') {
                    readFile(srcFile, 'utf8', (err, data) => {
                        if (err) {
                            console.error(`Error reading file: ${err.message}`);
                            return;
                        }

                        try {
                            const json = JSON.parse(data);
                            const abi = json.abi;

                            if (abi) {
                                const abiFile = join(destDir, file);
                                writeFile(abiFile, JSON.stringify(abi, null, 2), 'utf8', (err) => {
                                    if (err) {
                                        console.error(`Error writing file: ${err.message}`);
                                    } else {
                                        console.log(`Extracted ABI to ${abiFile}`);
                                    }
                                });
                            } else {
                                console.error(`No ABI found in ${srcFile}`);
                            }
                        } catch (parseErr) {
                            console.error(`Error parsing JSON in file ${srcFile}: ${parseErr.message}`);
                        }
                    });
                }
            });
        });
    });
};
processFiles(sourceDir, destDir);