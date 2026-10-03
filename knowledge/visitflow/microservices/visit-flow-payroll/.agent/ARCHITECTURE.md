# Payroll Architecture

`main.go → app/router.go → route/payroll_route.go → controller/payroll_controller_impl.go → service/payroll_service_impl.go → filesystem / IMAP / email / Telegram`.

There is no active local repository layer in this flow. main.go loads configuration and starts the router without initializing a payroll database. Dependency presence alone does not prove SQL-backed persistence.

Controller endpoints differ: FindFile writes bytes; list/count and OTP flows return JSON. Some service methods directly use Gin context; preserve current response ownership when extracting helpers. File/mail side effects are not transactionally coupled.
