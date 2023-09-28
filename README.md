# pixel_adventure



# Helper commands

if you're using windows and have assets with (parentheses) you can 
1. cd assets
2. run Get-ChildItem -Recurse -File | Where-Object { $_.Name -match "[()]" } | ForEach-Object {
   $newName = $_.Name -replace "[()]", ""
   Rename-Item $_.FullName -NewName $newName
   }
3. agen -t d -s -r lwu