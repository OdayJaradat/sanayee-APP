# Sanayee App - Run with Supabase

Write-Host "Starting Sanayee App with Supabase..." -ForegroundColor Green
Write-Host ""

# Supabase Configuration
$SUPABASE_URL = "https://ftulvlnmwhpvwvkvkpkm.supabase.co"
$SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ0dWx2bG5td2hwdnd2a3ZrcGttIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjExNTM3NjMsImV4cCI6MjA3NjcyOTc2M30.zfcYkiY70eIkXIVLWfwT4PhI68UwIxRheFFJK0SLQBE"

Write-Host "Backend: Supabase" -ForegroundColor Cyan
Write-Host "URL: $SUPABASE_URL" -ForegroundColor Cyan
Write-Host ""

# Run Flutter with Supabase configuration and authentication enabled
flutter run `
  --dart-define=BACKEND=supabase `
  --dart-define=SUPABASE_URL=$SUPABASE_URL `
  --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY `
  --dart-define=USE_AUTH=true
