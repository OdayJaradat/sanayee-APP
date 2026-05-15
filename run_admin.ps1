# Sanayee Admin Panel - Run Script

Write-Host "Starting Sanayee Admin Panel..." -ForegroundColor Green
Write-Host ""

# Supabase Configuration
$SUPABASE_URL = "ENTER YOUR SUPABASE URL HERE"
$SUPABASE_ANON_KEY = "ENTER YOUR SUPABASE ANON KEY HERE"

Write-Host "Backend: Supabase" -ForegroundColor Cyan
Write-Host "URL: $SUPABASE_URL" -ForegroundColor Cyan
Write-Host "Target: Admin Panel (Web Only)" -ForegroundColor Yellow
Write-Host ""

# Run Flutter Admin Panel with Supabase configuration
flutter run -d chrome -t lib/main_admin.dart `
  --dart-define=SUPABASE_URL=$SUPABASE_URL `
  --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY `
  --dart-define=USE_AUTH=true
