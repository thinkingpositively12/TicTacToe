# Script for switching Claude Code providers

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("openrouter", "anthropic", "deepseek")]
    [string]$Provider,
    [string]$OpenRouterKey = "" ,
    [string]$DeepSeekKey = "" ,
    [string]$DefaultModel = "deepseek/deepseek-v4-pro",
    [string]$FastModel = "deepseek/deepseek-v4-flash",
    [string]$ThinkingModel = "deepseek/deepseek-v4-pro"
)

switch ($Provider) {
    "openrouter" {
        [Environment]::SetEnvironmentVariable("ANTHROPIC_BASE_URL", "https://openrouter.ai/api", "User")
        [Environment]::SetEnvironmentVariable("ANTHROPIC_AUTH_TOKEN", $OpenRouterKey, "User")
        [Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", "", "User")
        [Environment]::SetEnvironmentVariable("ANTHROPIC_MODEL", $DefaultModel, "User")
        [Environment]::SetEnvironmentVariable("ANTHROPIC_SMALL_FAST_MODEL", $FastModel, "User")
        [Environment]::SetEnvironmentVariable("ANTHROPIC_THINKING_MODEL", $ThinkingModel, "User")
        Write-Host "Switched to OpenRouter" -ForegroundColor Green
        Write-Host "  Base URL      : https://openrouter.ai/api"
        Write-Host "  Auth          : $($OpenRouterKey.Substring(0, [Math]::Min(12, $OpenRouterKey.Length)))..."
        Write-Host "  Default Model : $DefaultModel"
        Write-Host "  Fast Model    : $FastModel"
        Write-Host "  Thinking Model: $ThinkingModel"
    }
    "anthropic" {
        [Environment]::SetEnvironmentVariable("ANTHROPIC_BASE_URL", $null, "User")
        [Environment]::SetEnvironmentVariable("ANTHROPIC_AUTH_TOKEN", $null, "User")
        [Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", $null, "User")
        [Environment]::SetEnvironmentVariable("ANTHROPIC_MODEL", $null, "User")
        [Environment]::SetEnvironmentVariable("ANTHROPIC_SMALL_FAST_MODEL", $null, "User")
        [Environment]::SetEnvironmentVariable("ANTHROPIC_THINKING_MODEL", $null, "User")
        Write-Host "Switched to Anthropic (OAuth/Pro)" -ForegroundColor Cyan
        Write-Host "  Cleared all overrides - Claude Code will use browser login and default models"
    }
    "deepseek" {
        if (-not $DeepSeekKey) {
            Write-Error "DeepSeek provider requires -DeepSeekKey parameter."
            exit 1
        }
        # DeepSeek's Anthropic-compatible endpoint
        [Environment]::SetEnvironmentVariable("ANTHROPIC_BASE_URL", "https://api.deepseek.com/anthropic", "User")
        [Environment]::SetEnvironmentVariable("ANTHROPIC_AUTH_TOKEN", $DeepSeekKey, "User")
        [Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", "", "User")
        # Recommend using DeepSeek models: flash for speed, pro for complex reasoning
        $deepSeekDefault  = "deepseek-v4-pro"
        $deepSeekFast     = "deepseek-v4-flash"
        $deepSeekThinking = "deepseek-v4-pro"
        [Environment]::SetEnvironmentVariable("ANTHROPIC_MODEL", $deepSeekDefault, "User")
        [Environment]::SetEnvironmentVariable("ANTHROPIC_SMALL_FAST_MODEL", $deepSeekFast, "User")
        [Environment]::SetEnvironmentVariable("ANTHROPIC_THINKING_MODEL", $deepSeekThinking, "User")
        Write-Host "Switched to DeepSeek" -ForegroundColor Magenta
        Write-Host "  Base URL      : https://api.deepseek.com/anthropic"
        Write-Host "  Auth          : $($DeepSeekKey.Substring(0, [Math]::Min(12, $DeepSeekKey.Length)))..."
        Write-Host "  Default Model : $deepSeekDefault"
        Write-Host "  Fast Model    : $deepSeekFast"
        Write-Host "  Thinking Model: $deepSeekThinking"
        Write-Host ""
        Write-Host "Note: DeepSeek is pay-as-you-go. Make sure your account has credits." -ForegroundColor Yellow
    }
}
