# Script para configurar temporalmente el PATH de Node.js
$nodePath = "C:\Program Files\nodejs"
$env:Path += ";$nodePath"
Write-Host "Node.js ha sido agregado al PATH de esta sesión"
Write-Host "Intenta ejecutar 'node --version' ahora"
