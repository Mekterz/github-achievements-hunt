$ghPath = "C:\Program Files\GitHub CLI\gh.exe"
$repoId = "R_kgDOSd7JBg"
$categoryId = "DIC_kwDOSd7JBs4C9FfX"

for ($i = 3; $i -le 8; $i++) {
    Write-Host "Creating discussion $i..."
    
    # Create discussion
    $createMutation = "mutation { createDiscussion(input: {repositoryId: `"$repoId`", categoryId: `"$categoryId`", title: `"Achievement Discussion $i`", body: `"Question for badge $i`"}) { discussion { id } } }"
    [System.IO.File]::WriteAllText("temp_query.graphql", $createMutation)
    $createResult = & $ghPath api graphql -F query=@temp_query.graphql | ConvertFrom-Json
    $discussionId = $createResult.data.createDiscussion.discussion.id
    
    # Add comment
    $commentMutation = "mutation { addDiscussionComment(input: {discussionId: `"$discussionId`", body: `"Answer for badge $i`"}) { comment { id } } }"
    [System.IO.File]::WriteAllText("temp_query.graphql", $commentMutation)
    $commentResult = & $ghPath api graphql -F query=@temp_query.graphql | ConvertFrom-Json
    $commentId = $commentResult.data.addDiscussionComment.comment.id
    
    # Mark as answer
    $acceptMutation = "mutation { markDiscussionCommentAsAnswer(input: {id: `"$commentId`"}) { discussion { id } } }"
    [System.IO.File]::WriteAllText("temp_query.graphql", $acceptMutation)
    & $ghPath api graphql -F query=@temp_query.graphql
}
if (Test-Path "temp_query.graphql") { Remove-Item "temp_query.graphql" }
