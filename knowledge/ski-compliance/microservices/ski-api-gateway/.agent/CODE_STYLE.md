# .agent/CODE_STYLE.md

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

## Observed Code Style & Conventions

This document records the coding style, patterns, and conventions discovered across `ski-api-gateway`.

---

## 1. Package Structure & Naming

- Standard packages are grouped under root directories: `cmd/`, `pkg/app`, `pkg/auth`, `pkg/config`, `helper/`, `exception/`, and `model/web`.
- Package names are singular and lowercase: `package app`, `package auth`, `package config`, `package helper`, `package exception`, `package web`.
- File names use snake_case: `api_key.go`, `block_acces.go`, `error_handler.go`, `reverse_proxy.go`, `web_response.go`.

---

## 2. Panic and Error Handling Style

- The legacy convention frequently uses `helper.PanicIfError(err)` for fast failure in middleware and service initializers:
  ```go
  func PanicIfError(err error) {
      if err != nil {
          panic(err)
      }
  }
  ```
- Panics are intercepted at the Gin middleware boundary by `app.ErrorHandler()`, which passes recovered errors to `exception.ErrorHandler(c, err)`:
  ```go
  func ErrorHandler() gin.HandlerFunc {
      return func(c *gin.Context) {
          defer func() {
              if err := recover(); err != nil {
                  fmt.Println("stacktrace from panic: \n" + string(debug.Stack()))
                  exception.ErrorHandler(c, err)
              }
          }()
          c.Next()
      }
  }
  ```
- New code should prefer returning explicit `error` values where practical, only relying on `PanicIfError` when interacting with legacy panic-recovery middleware.

---

## 3. Configuration & Dependency Wiring

- Structs use `mapstructure` tags for Viper compatibility:
  ```go
  type Config struct {
      Port          string `mapstructure:"PORT"`
      AccessSecret  string `mapstructure:"ACCESS_SECRET"`
      RefreshSecret string `mapstructure:"REFRESH_SECRET"`
  }
  ```
- Constructors return concrete pointers and error: `func LoadConfig() (c *Config, err error)`.
- Router initialization accepts `*config.Config` and returns `*gin.Engine`: `func NewRouter(c *config.Config) *gin.Engine`.

---

## 4. Concurrency & Synchronization

- Global state (e.g., `ipAccessTracker`, `blockList`, `ApiKeyManager`) uses mutexes (`sync.Mutex` or `sync.RWMutex`) and `sync.Once` for thread safety:
  ```go
  var (
      apiKeyMgrInstance *ApiKeyManager
      apiKeyOnce        sync.Once
  )
  ```
- Timers for unblocking IPs use `time.AfterFunc` with lock acquisition inside the callback:
  ```go
  time.AfterFunc(blockDuration, func() {
      mutex.Lock()
      delete(blockList, clientIP)
      delete(ipAccessTracker, clientIP)
      mutex.Unlock()
  })
  ```

---

## 5. Struct & JSON Tagging

- Response structs use `json` tags with camelCase/snake_case:
  ```go
  type WebResponse struct {
      Success bool        `json:"success"`
      Message string      `json:"message"`
      Data    interface{} `json:"data"`
  }
  ```
- CSV mapping structs use `csv` tags:
  ```go
  type UserAccessCsv struct {
      UserID        string `csv:"user_id"`
      Name          string `csv:"name"`
      MenuSidebarID string `csv:"menu_sidebar_id"`
      AddAccess     string `csv:"add_access"`
      ...
  }
  ```

---

## 6. Formatting & Tooling

- Standard Go formatting: enforce `go fmt ./...` on all source files.
- Static checking: enforce `go vet ./...` clean output.
