# Sanayee App - Run with Supabase

Write-Host "Starting Sanayee App with Supabase..." -ForegroundColor Green
Write-Host ""

# Supabase Configuration
$SUPABASE_URL = "hENTER YOUR SUPABASE URL HERE"
$SUPABASE_ANON_KEY = "ENTER YOUR SUPABASE ANON KEY HERE"

Write-Host "Backend: Supabase" -ForegroundColor Cyan
Write-Host "URL: $SUPABASE_URL" -ForegroundColor Cyan
Write-Host ""

# Run Flutter with Supabase configuration and authentication enabled
flutter run `
  --dart-define=BACKEND=supabase `
  --dart-define=SUPABASE_URL=$SUPABASE_URL `
  --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY `
  --dart-define=USE_AUTH=true
