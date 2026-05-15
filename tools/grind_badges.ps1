$ghPath = "C:\Program Files\GitHub CLI\gh.exe"
for ($i = 1; $i -le 15; $i++) {
    $branchName = "badge-grind-$i"
    Write-Host "Processing $branchName..."
    
    # Create branch
    git checkout -b $branchName
    
    # Create dummy file
    "Dummy content for achievement grind $i" > "grind_$i.txt"
    
    # Add and commit with co-author
    git add "grind_$i.txt"
    git commit -m "Grind achievement $i`n`nCo-authored-by: GitHub Copilot <copilot@github.com>"
    
    # Push branch
    git push origin $branchName
    
    # Create PR
    & $ghPath pr create --title "Grind Achievement $i" --body "Automated PR for badge progress." --base master --head $branchName
    
    # Merge PR
    & $ghPath pr merge --merge --admin
    
    # Back to master
    git checkout master
    git pull origin master
}
