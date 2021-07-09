# ImageMerger

With this Tool, you can merge Object-Photos (with transparent background) on custom backgrounds.
It generates automatically all needed config data for use with darknet.

## Parameters

| Command | Info |
|---|---|
| -b or --background | The Path to the Folder where the pictures are in |
| -c or --classes | The Path to the Folder where the Classes are in. Each Class should be in its own sub-folder |
| -o or --output | The Path to the output directory |
| -i oder --imagecount | The amount of Training-Pictures that should be created. Has to be divisible by the isolate-count |
| -t oder --testcount | The amount of Validation-Pictures that should be created. Has to be divisible by the isolate-count  |
| --min | Optional: The minimum count of objects placed on one background |
| --max | Optional: The maximum count of objects placed on one background |
| --minsize | Optional: The minimum size of an object in % |
| --maxsize | Optional: The maximum size of an object in % |
| -l or --lable | Optional: Flag if an additional directory with images with added bounding boxes should be exported |
| --isolates | Optional: The isolate count. Each isolate is its own thread. Should be 2x the amount of cores the system has |
