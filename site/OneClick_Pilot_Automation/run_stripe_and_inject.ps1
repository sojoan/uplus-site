param(
  [Parameter(Mandatory=$true)][string]$StripeKey,
  [string]$OffersJson = "..\AME_Suite_v15_1_Pilot\configs\pilot_mode.json",
  [string]$EdgeFolder = "..\UPlus_Edge_Pilot_v15_1"
)

Write-Host "Reading offers from $OffersJson"
$offers = Get-Content $OffersJson | ConvertFrom-Json
$links = @{}

foreach($o in $offers.offers){
  $name = $o.title
  $slug = $o.slug
  $price = [int]($o.price * 100)
  $currency = "eur"

  # 1) Create product
  $prod = curl.exe https://api.stripe.com/v1/products -u $StripeKey: -d "name=$name" -d "statement_descriptor_suffix=UPLUS" | ConvertFrom-Json
  if(-not $prod.id){ throw "Stripe product error for $name" }

  # 2) Create price
  if($o.type -eq "subs"){
    $priceObj = curl.exe https://api.stripe.com/v1/prices -u $StripeKey: -d "unit_amount=$price" -d "currency=$currency" -d "product=$($prod.id)" -d "recurring[interval]=month" -d "recurring[trial_period_days]=3" | ConvertFrom-Json
  } else {
    $priceObj = curl.exe https://api.stripe.com/v1/prices -u $StripeKey: -d "unit_amount=$price" -d "currency=$currency" -d "product=$($prod.id)" | ConvertFrom-Json
  }
  if(-not $priceObj.id){ throw "Stripe price error for $name" }

  # 3) Create payment link
  $plink = curl.exe https://api.stripe.com/v1/payment_links -u $StripeKey: -d "line_items[0][price]=$($priceObj.id)" -d "line_items[0][quantity]=1" | ConvertFrom-Json
  if(-not $plink.url){ throw "Stripe payment link error for $name" }

  $links[$slug] = $plink.url
  Write-Host "Created Payment Link for $name => $($plink.url)"
}

# Save links
$links | ConvertTo-Json | Out-File "$EdgeFolder\payment_links.json" -Encoding UTF8

# Inject links into checkout pages
Get-ChildItem "$EdgeFolder\site" -Filter "checkout_*.html" | ForEach-Object {
  $file = $_.FullName
  $content = Get-Content $file -Raw
  foreach($k in $links.Keys){
    if($file -like "*checkout_$k.html"){
      $url = $links[$k]
      $content = $content -replace 'href="#"', "href=`"$url`""
    }
  }
  $content | Out-File $file -Encoding UTF8
  Write-Host "Injected link into $file"
}

Write-Host "Done. Links injected and saved at $EdgeFolder\payment_links.json"
