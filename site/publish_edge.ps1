param(
  [Parameter(Mandatory=$true)][string]$Owner,
  [Parameter(Mandatory=$true)][string]$Repo,
  [string]$EdgeFolder = "..\UPlus_Edge_Pilot_v15_1"
)

# Tools check
function Need($cmd,$url){
  if(-not (Get-Command $cmd -ErrorAction SilentlyContinue)){ Write-Error "$cmd not found. Install: $url"; exit 1 }
}
Need git "https://git-scm.com"
Need gh "https://cli.github.com"
Need node "https://nodejs.org"

# RSA keypair (OpenSSL or Node fallback)
Set-Location $EdgeFolder
if(-not (Test-Path "core_sign.pem")){
  if(Get-Command openssl -ErrorAction SilentlyContinue){
    openssl genrsa -out core_sign.pem 2048 | Out-Null
    openssl rsa -in core_sign.pem -pubout -out core_sign.pub | Out-Null
  } else {
    # Node fallback
    node -e "const c=require('crypto');const {privateKey,publicKey}=c.generateKeyPairSync('rsa',{modulusLength:2048});require('fs').writeFileSync('core_sign.pem',privateKey.export({type:'pkcs1',format:'pem'}));require('fs').writeFileSync('core_sign.pub',publicKey.export({type:'spki',format:'pem'}));"
  }
  Write-Host "RSA keys generated."
}

# Sign pricing.json (Node)
@'
const fs=require("fs"), crypto=require("crypto");
const key=fs.readFileSync("core_sign.pem");
const data=fs.readFileSync("configs/pricing.json");
const sign=crypto.createSign("RSA-SHA256"); sign.update(data); sign.end();
fs.writeFileSync("configs/pricing.json.sig", sign.sign(key).toString("base64"));
console.log("signed pricing.json");
'@ | Out-File "sign_pricing.js" -Encoding UTF8
node sign_pricing.js

# Init repo and push
gh auth status
$dest = "$env:TEMP\$Repo"
if(Test-Path $dest){ Remove-Item $dest -Recurse -Force }
git init $dest | Out-Null
Copy-Item -Recurse -Force "$EdgeFolder\*" $dest
Set-Location $dest
git add .
git commit -m "edge pilot initial" | Out-Null

# Create remote if not exists
$exists = gh repo view "$Owner/$Repo" 2>$null
if($LASTEXITCODE -ne 0){
  gh repo create "$Owner/$Repo" --public -y
}
git branch -M main
git remote add origin "https://github.com/$Owner/$Repo.git" 2>$null
git push -u origin main

# Enable GitHub Pages (deploy from branch, /)
gh api -X POST repos/$Owner/$Repo/pages -f "source[branch]=main" -f "source[path]=/"
Write-Host "GitHub Pages requested. If API returns 409, Pages likely already enabled."

Write-Host "Published. Visit: https://$Owner.github.io/$Repo/"
