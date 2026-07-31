# XCUITest CI/CD Only Setup

## Overview

Este projeto é configurado para rodar **apenas em GitHub Actions**. Você não precisa instalar Xcode ou qualquer dependência local.

```
┌─────────────────────┐
│   Seu Computador    │
│                     │
│  - Git commit       │
│  - git push         │
│  (sem Xcode!)       │
└──────────┬──────────┘
           │
           ↓
┌─────────────────────────────┐
│  GitHub Actions (Cloud)     │
│                             │
│  - Xcode pré-instalado      │
│  - Run XCUITests            │
│  - Upload results           │
│  - Show status              │
└─────────────────────────────┘
```

## Como Funciona

1. **Você faz commit** → `git push origin main`
2. **GitHub Actions dispara** → `.github/workflows/xcode-tests.yml`
3. **macOS runner (cloud) executa** → `xcodebuild test`
4. **Resultados aparecem** → GitHub Actions > Artifacts

## Setup (Sem Xcode)

### 1. Clone o Repositório

```bash
git clone https://github.com/gustavaom7/xcuitest-portfolio.git
cd xcuitest-portfolio
```

### 2. Edite Código (Em qualquer editor)

```bash
# VSCode, Sublime Text, Vim, etc.
code .
```

### 3. Commit & Push

```bash
git add .
git commit -m "Minha alteração"
git push origin main
```

### 4. Veja Testes Rodando

1. Abra GitHub → Actions tab
2. Veja workflow executando em tempo real
3. Download de artifacts com resultados

## Workflow

Arquivo: `.github/workflows/xcode-tests.yml`

Roda em:
- ✅ **Toda semana** (segunda-feira 09:00 UTC)
- ✅ **Cada push** para `main`
- ✅ **Cada PR** para `main`
- ✅ **Manualmente** (workflow_dispatch)

## Verificar Resultados

### Via GitHub UI

1. Repositório → **Actions** tab
2. Clique workflow recente
3. Ver status (✅ passed / ❌ failed)
4. Download artifacts: `xctest-results-*`

### Via CLI

```bash
# Listar últimas execuções
gh run list

# Ver detalhes de execução específica
gh run view <RUN_ID>

# Download artifacts
gh run download <RUN_ID> -n xctest-results-iPhone15-17.5
```

## Estrutura de Arquivos

```
xcuitest-portfolio/
├── .github/workflows/
│   └── xcode-tests.yml          # ← GitHub Actions workflow
├── SampleAppUITests/            # ← Code que roda em CI
│   ├── BaseTestCase.swift
│   ├── Pages/
│   │   └── *.swift
│   ├── Tests/
│   │   └── *Tests.swift
│   └── Utils/
│       └── *.swift
├── docs/                        # ← Documentação local
├── README.md
└── SETUP.md
```

## Editar Testes

Você pode editar código XCUITest sem Xcode:

```bash
# Exemplo: editar LoginTests.swift
vim SampleAppUITests/Tests/LoginTests.swift
# ou abrir em qualquer editor
```

Depois fazer push:

```bash
git add SampleAppUITests/Tests/LoginTests.swift
git commit -m "Update LoginTests with new test cases"
git push
```

GitHub Actions vai compilar + rodar + reportar resultados.

## Limitações (CI/CD Only)

| Tarefa | Possible? | Alternativa |
|--------|-----------|-------------|
| Rodar testes localmente | ❌ Não (sem Xcode) | Push → CI roda |
| Debug no Xcode | ❌ Não (sem Xcode) | Usar logs de CI |
| Testar em device físico | ❌ Não (sem setup) | Usar simulador em CI |
| Compilar app localmente | ❌ Não (sem Xcode) | CI compila |

## Troubleshooting

### Testes falhando em CI

1. Abra workflow run → **View logs**
2. Procure por erros na saída
3. Edite código localmente → commit → push
4. Workflow roda de novo automaticamente

### Exemplo: Teste falhando

```bash
# Ver o que falhou
# GitHub Actions mostra erro:
# "Element 'loginEmailTextField' not found"

# Editar localmente
vim SampleAppUITests/Pages/LoginPage.swift

# Corrigir identifier
# Commit & push
git push

# GitHub Actions executa novamente
```

## Melhor Prática

1. **Editar localmente** (qualquer editor)
2. **Commit** com mensagem clara
3. **Push** para main/PR
4. **CI roda** automaticamente
5. **Reviewer vê** status (✅/❌) na PR
6. **Merge** quando CI passar

## Próximas Ações

- [ ] Push para GitHub
- [ ] Verificar primeiro workflow run
- [ ] Adicionar mais testes
- [ ] Ajustar CI conforme necessário

---

**Resumo**: Você trabalha localmente sem Xcode. GitHub Actions testa tudo na cloud. Win-win! 🚀
