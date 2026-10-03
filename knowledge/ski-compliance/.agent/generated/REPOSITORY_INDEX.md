# Repository index

Generated from current checkout and go.mod. Pinned dependencies are not assumed identical to local sibling checkouts. Test inventory is not proof tests ran.

| Repo | Scope | Branch | HEAD | Go | Source files | Route declarations |
|---|---|---|---|---|---|---|
| flexurio-nocode-api-config-mf-marketing | reference only | add-export-incentive-header | ad4b8f3f108d | NULL | 0 | 0 |
| flexurio-nocode-web-config-mf-marketing | reference only | feat/update-incentive-export-urls-and-actions | 2776b9cd8f85 | NULL | 0 | 0 |
| mf-micro-service-bank | documentation | CU-86cwcwyt9-otc | 273a5dc69775 | 1.19 | 84 | 27 |
| mf-micro-service-customer | documentation | add-pagination-customer-prod-outlet | d5e2bf1db02b | 1.23 | 119 | 43 |
| mf-micro-service-discount-proposal | reference only | feat/all-improvements-tests-ci | 5dde98ade3b1 | 1.23 | 403 | 177 |
| mf-micro-service-event | documentation | CU-86cwcx137-otc | a6be31a45350 | 1.19 | 83 | 27 |
| mf-micro-service-marketing-user | documentation | non-active-auth-csv | f8e5345a9c5e | 1.23 | 103 | 35 |
| mf-micro-service-master-document-proposal | documentation | main | ecd39670cfa7 | 1.23 | 66 | 19 |
| mf-micro-service-outlet-2 | documentation | feat-outlet-groups-and-mappings | 2c27cc8952de | 1.23 | 87 | 28 |
| mf-micro-service-product | documentation | change-max-id-product-program | cf92969c29c7 | 1.19 | 140 | 51 |
| mf-micro-service-sales | reference only | fix/morses-empty-data-response | 5e34afeedfe7 | 1.23 | 197 | 62 |
| mf-micro-service-structure | reference only | feat/all-improvements | 82963b5f7a8c | 1.23 | 134 | 57 |
| rest-api-pondasi-mftl | reference only | feat/offline-presence-csv | 87dda5ff2e32 | 1.19 | 253 | 0 |
| ski-api-gateway | reference only | feat/modular-router-and-test-coverage | 5f810f17396b | 1.23 | 38 | 0 |
| ski-compliance-api-warehouse | documentation | feat/validate-data-product-and-gt | 55d6e4d277ff | 1.23 | 418 | 73 |
| visit-flow-api-synchronize-ski-compliance | documentation | CU-86d16bvpw-add-sync-user-telegram | 42d46c39ff30 | 1.23 | 85 | 10 |

## flexurio-nocode-api-config-mf-marketing

Module: `None`.

Internal dependencies (go.mod):
- None declared.

Test files: none observed.

## flexurio-nocode-web-config-mf-marketing

Module: `None`.

Internal dependencies (go.mod):
- None declared.

Test files: none observed.

## mf-micro-service-bank

Module: `gitlab.com/VNEU/mf-micro-service-bank`.

Internal dependencies (go.mod):
- `gitlab.com/VNEU/mf-micro-service-customer v0.1.8-release.0.20230815010900-8fb2d0efd1dd`
- `gitlab.com/VNEU/mf-micro-service-marketing-user v0.1.6-release`
- `gitlab.com/VNEU/ski-api-gateway v0.0.5-m.0.20230921094706-1a732d85309d`
- `gitlab.com/VNEU/mf-micro-service-product v0.1.21-release.0.20230721024742-18b8188263f1`
- `gitlab.com/VNEU/mf-micro-service-city v0.1.8-release.0.20230630081354-80fdf541c02b`
- `gitlab.com/VNEU/mf-micro-service-outlet-2 v0.1.20-m-5`

Test files:
- `mf-micro-service-bank/helper/operator_test.go`

## mf-micro-service-customer

Module: `gitlab.com/VNEU/mf-micro-service-customer`.

Internal dependencies (go.mod):
- `gitlab.com/VNEU/mf-micro-service-city v0.1.8-release.0.20230630081354-80fdf541c02b`
- `gitlab.com/VNEU/mf-micro-service-counter v0.1.10-release`
- `gitlab.com/VNEU/mf-micro-service-marketing-user v0.1.6-release`
- `gitlab.com/VNEU/mf-micro-service-outlet-2 v0.1.20-m-5`
- `gitlab.com/VNEU/mf-micro-service-product v0.1.21-release.0.20231009073856-a2e902e3dfba`
- `gitlab.com/VNEU/mf-micro-service-bank v0.1.16-m.0.20240502061816-8415f0af8957`
- `gitlab.com/vneu/go-helper v0.2.9-rc.0.20240429005410-765afc8d4ec5`
- `gitlab.com/VNEU/ski-api-gateway v0.0.5-m.0.20230921094706-1a732d85309d`

Test files:
- `mf-micro-service-customer/helper/operator_test.go`

## mf-micro-service-discount-proposal

Module: `gitlab.com/VNEU/mf-micro-service-discount-proposal`.

Internal dependencies (go.mod):
- `gitlab.com/VNEU/go-helper v0.5.4`
- `gitlab.com/VNEU/mf-micro-service-bank v0.1.13-m.0.20240308070357-e378b42391d5`
- `gitlab.com/VNEU/mf-micro-service-city v0.1.8-release.0.20230630081354-80fdf541c02b`
- `gitlab.com/VNEU/mf-micro-service-counter v0.1.0`
- `gitlab.com/VNEU/mf-micro-service-distributor v0.1.8-release.0.20230614012329-a4a68f331197`
- `gitlab.com/VNEU/mf-micro-service-event v0.1.9-release.0.20230803011316-49f9c085989d`
- `gitlab.com/VNEU/mf-micro-service-marketing-user v0.1.6-release`
- `gitlab.com/VNEU/mf-micro-service-master-document-proposal v0.1.10-release`
- `gitlab.com/VNEU/mf-micro-service-outlet-2 v0.1.20-m-5`
- `gitlab.com/VNEU/mf-micro-service-product v0.1.21-release.0.20230721024742-18b8188263f1`
- `gitlab.com/VNEU/mf-micro-service-structure v0.1.61-release`
- `gitlab.com/VNEU/mf-micro-service-customer v0.1.8-release.0.20230815010900-8fb2d0efd1dd`
- `gitlab.com/VNEU/mf-micro-service-sales v0.1.9-m.0.20240228063052-4e49d5acbac7`
- `gitlab.com/VNEU/ski-api-gateway v0.0.5-m.0.20230921094706-1a732d85309d`

Test files:
- `mf-micro-service-discount-proposal/test/app_router_database_test.go`
- `mf-micro-service-discount-proposal/test/auth_test.go`
- `mf-micro-service-discount-proposal/test/controller_all_test.go`
- `mf-micro-service-discount-proposal/test/controller_deep_complete_test.go`
- `mf-micro-service-discount-proposal/test/controller_final_push_test.go`
- `mf-micro-service-discount-proposal/test/controller_multipart_test.go`
- `mf-micro-service-discount-proposal/test/controller_test.go`
- `mf-micro-service-discount-proposal/test/coverage_credit_note_create_test.go`
- `mf-micro-service-discount-proposal/test/coverage_final_push_90_test.go`
- `mf-micro-service-discount-proposal/test/coverage_overdrive_90_test.go`
- `mf-micro-service-discount-proposal/test/coverage_supercharge_90_test.go`
- `mf-micro-service-discount-proposal/test/coverage_supercharge_bonus_test.go`
- `mf-micro-service-discount-proposal/test/custom_validator_test.go`
- `mf-micro-service-discount-proposal/test/domain_and_repo_full_coverage_test.go`
- `mf-micro-service-discount-proposal/test/domain_mapper_complete_test.go`
- `mf-micro-service-discount-proposal/test/domain_mapper_test.go`
- `mf-micro-service-discount-proposal/test/exception_test.go`
- `mf-micro-service-discount-proposal/test/helper_complete_test.go`
- `mf-micro-service-discount-proposal/test/helper_exhaustive_test.go`
- `mf-micro-service-discount-proposal/test/helper_test.go`
- `mf-micro-service-discount-proposal/test/push_to_90_all_routes_supercharge_test.go`
- `mf-micro-service-discount-proposal/test/push_to_90_apex_booster_test.go`
- `mf-micro-service-discount-proposal/test/push_to_90_apex_champion_test.go`
- `mf-micro-service-discount-proposal/test/push_to_90_apex_final_test.go`
- `mf-micro-service-discount-proposal/test/push_to_90_apex_grand_champion_test.go`
- `mf-micro-service-discount-proposal/test/push_to_90_apex_victory_finale_test.go`
- `mf-micro-service-discount-proposal/test/push_to_90_apex_victory_strikes_test.go`
- `mf-micro-service-discount-proposal/test/push_to_90_apex_victory_ultimate_test.go`
- `mf-micro-service-discount-proposal/test/push_to_90_champion_overdrive_test.go`
- `mf-micro-service-discount-proposal/test/push_to_90_champion_test.go`
- `mf-micro-service-discount-proposal/test/push_to_90_final_champion_strikes_test.go`
- `mf-micro-service-discount-proposal/test/push_to_90_final_champion_test.go`
- `mf-micro-service-discount-proposal/test/push_to_90_final_legend_mastery_test.go`
- `mf-micro-service-discount-proposal/test/push_to_90_final_stretch_legend_test.go`
- `mf-micro-service-discount-proposal/test/push_to_90_final_stretch_test.go`
- `mf-micro-service-discount-proposal/test/push_to_90_final_strike_test.go`
- `mf-micro-service-discount-proposal/test/push_to_90_final_strike_victory_test.go`
- `mf-micro-service-discount-proposal/test/push_to_90_final_victory_test.go`
- `mf-micro-service-discount-proposal/test/push_to_90_grand_master_test.go`
- `mf-micro-service-discount-proposal/test/push_to_90_immortal_champion_test.go`
- `mf-micro-service-discount-proposal/test/push_to_90_immortal_overlord_final_finish_test.go`
- `mf-micro-service-discount-proposal/test/push_to_90_immortal_overlord_victory_test.go`
- `mf-micro-service-discount-proposal/test/push_to_90_immortal_victory_test.go`
- `mf-micro-service-discount-proposal/test/push_to_90_legendary_final_strike_test.go`
- `mf-micro-service-discount-proposal/test/push_to_90_legendary_victory_test.go`
- `mf-micro-service-discount-proposal/test/push_to_90_mega_coverage_test.go`
- `mf-micro-service-discount-proposal/test/push_to_90_super_apex_final_victory_test.go`
- `mf-micro-service-discount-proposal/test/push_to_90_super_champion_test.go`
- `mf-micro-service-discount-proposal/test/push_to_90_super_coverage_test.go`
- `mf-micro-service-discount-proposal/test/push_to_90_super_ultimate_victory_test.go`
- `mf-micro-service-discount-proposal/test/push_to_90_super_victory_test.go`
- `mf-micro-service-discount-proposal/test/push_to_90_supercharge_all_services_test.go`
- `mf-micro-service-discount-proposal/test/push_to_90_titan_booster_test.go`
- `mf-micro-service-discount-proposal/test/push_to_90_ultra_targeted_test.go`
- `mf-micro-service-discount-proposal/test/push_to_90_value_recalc_mastery_test.go`
- `mf-micro-service-discount-proposal/test/push_to_90_victory_final_test.go`
- `mf-micro-service-discount-proposal/test/repository_all_test.go`
- `mf-micro-service-discount-proposal/test/repository_test.go`
- `mf-micro-service-discount-proposal/test/route_test.go`
- `mf-micro-service-discount-proposal/test/service_all_test.go`
- `mf-micro-service-discount-proposal/test/service_confirmation_deep_test.go`
- `mf-micro-service-discount-proposal/test/service_confirmation_full_coverage_test.go`
- `mf-micro-service-discount-proposal/test/service_coverage_deep_ultimate_test.go`
- `mf-micro-service-discount-proposal/test/service_coverage_final_push_test.go`
- `mf-micro-service-discount-proposal/test/service_credit_note_deep_test.go`
- `mf-micro-service-discount-proposal/test/service_credit_note_full_coverage_test.go`
- `mf-micro-service-discount-proposal/test/service_credit_note_test.go`
- `mf-micro-service-discount-proposal/test/service_deep_coverage_test.go`
- `mf-micro-service-discount-proposal/test/service_deep_mega_test.go`
- `mf-micro-service-discount-proposal/test/service_deep_test.go`
- `mf-micro-service-discount-proposal/test/service_deep_ultra_test.go`
- `mf-micro-service-discount-proposal/test/service_discount_proposal_confirmation_test.go`
- `mf-micro-service-discount-proposal/test/service_discount_proposal_full_coverage_test.go`
- `mf-micro-service-discount-proposal/test/service_discount_proposal_payment_test.go`
- `mf-micro-service-discount-proposal/test/service_discount_proposal_recipient_test.go`
- `mf-micro-service-discount-proposal/test/service_discount_proposal_test.go`
- `mf-micro-service-discount-proposal/test/service_estimation_deep_test.go`
- `mf-micro-service-discount-proposal/test/service_estimation_return_status_test.go`
- `mf-micro-service-discount-proposal/test/service_exhaustive_coverage_test.go`
- `mf-micro-service-discount-proposal/test/service_misc_test.go`
- `mf-micro-service-discount-proposal/test/service_payment_deep_test.go`
- `mf-micro-service-discount-proposal/test/service_payment_full_coverage_test.go`
- `mf-micro-service-discount-proposal/test/service_recipient_deep_test.go`
- `mf-micro-service-discount-proposal/test/service_recipient_full_coverage_test.go`
- `mf-micro-service-discount-proposal/test/service_target_90_test.go`
- `mf-micro-service-discount-proposal/test/supercharge_all_targets_90_test.go`

## mf-micro-service-event

Module: `gitlab.com/VNEU/mf-micro-service-event`.

Internal dependencies (go.mod):
- `gitlab.com/VNEU/mf-micro-service-city v0.1.8-release.0.20230630081354-80fdf541c02b`
- `gitlab.com/VNEU/mf-micro-service-marketing-user v0.1.6-release`
- `gitlab.com/VNEU/mf-micro-service-outlet-2 v0.1.20-m-5`
- `gitlab.com/VNEU/mf-micro-service-product v0.1.21-release.0.20231009073856-a2e902e3dfba`
- `gitlab.com/VNEU/mf-micro-service-bank v0.1.9-m.0.20231002023649-692dd3be08b1`
- `gitlab.com/VNEU/mf-micro-service-customer v0.1.10-release.0.20231023042624-f84db17a9ae9`
- `gitlab.com/VNEU/ski-api-gateway v0.0.5-m.0.20230921094706-1a732d85309d`
- `gitlab.com/vneu/go-helper v0.2.0-rc`

Test files:
- `mf-micro-service-event/helper/operator_test.go`

## mf-micro-service-marketing-user

Module: `gitlab.com/VNEU/mf-micro-service-marketing-user`.

Internal dependencies (go.mod):
- `gitlab.com/VNEU/ski-api-gateway v0.0.5-m.0.20230921094706-1a732d85309d`

Test files:
- `mf-micro-service-marketing-user/helper/operator_test.go`

## mf-micro-service-master-document-proposal

Module: `gitlab.com/VNEU/mf-micro-service-master-document-proposal`.

Internal dependencies (go.mod):
- `gitlab.com/VNEU/mf-micro-service-marketing-user v0.1.0`

Test files:
- `mf-micro-service-master-document-proposal/helper/operator_test.go`

## mf-micro-service-outlet-2

Module: `gitlab.com/VNEU/mf-micro-service-outlet-2`.

Internal dependencies (go.mod):
- `gitlab.com/VNEU/mf-micro-service-city v0.1.0`
- `gitlab.com/VNEU/mf-micro-service-counter v0.1.10-release`
- `gitlab.com/VNEU/mf-micro-service-marketing-user v0.1.0`
- `gitlab.com/VNEU/mf-micro-service-structure v0.1.42-m.0.20250220072238-fa0972c4d04d`
- `gitlab.com/vneu/go-helper v0.2.9-rc.0.20240429005410-765afc8d4ec5`
- `gitlab.com/VNEU/mf-micro-service-customer v0.1.8-release.0.20230815010900-8fb2d0efd1dd`
- `gitlab.com/VNEU/mf-micro-service-product v0.1.21-release.0.20230721024742-18b8188263f1`

Test files:
- `mf-micro-service-outlet-2/helper/operator_test.go`

## mf-micro-service-product

Module: `gitlab.com/VNEU/mf-micro-service-product`.

Internal dependencies (go.mod):
- `gitlab.com/VNEU/mf-micro-service-city v0.1.8-m.0.20230918061145-fdc14141a6ff`
- `gitlab.com/VNEU/mf-micro-service-marketing-user v0.1.6-release`
- `gitlab.com/VNEU/ski-api-gateway v0.0.5-m.0.20230921094706-1a732d85309d`
- `gitlab.com/vneu/go-helper v0.2.0-rc`

Test files:
- `mf-micro-service-product/helper/operator_test.go`

## mf-micro-service-sales

Module: `gitlab.com/VNEU/mf-micro-service-sales`.

Internal dependencies (go.mod):
- `gitlab.com/VNEU/mf-micro-service-structure v0.1.61-release`
- `gitlab.com/vneu/go-helper v0.2.17-rc`
- `gitlab.com/VNEU/mf-micro-service-bank v0.1.13-m.0.20240308070357-e378b42391d5`
- `gitlab.com/VNEU/mf-micro-service-customer v0.1.8-release.0.20230815010900-8fb2d0efd1dd`
- `gitlab.com/VNEU/mf-micro-service-discount-proposal v0.4.92-release.0.20260127040119-2c074c43c7b0`
- `gitlab.com/VNEU/mf-micro-service-event v0.1.9-release.0.20230803011316-49f9c085989d`
- `gitlab.com/VNEU/mf-micro-service-master-document-proposal v0.1.10-release`
- `gitlab.com/VNEU/mf-micro-service-city v0.1.8-release.0.20230630081354-80fdf541c02b`
- `gitlab.com/VNEU/mf-micro-service-distributor v0.1.8-release.0.20230614012329-a4a68f331197`
- `gitlab.com/VNEU/mf-micro-service-marketing-user v0.1.6-release`
- `gitlab.com/VNEU/mf-micro-service-outlet-2 v0.1.20-m-5`
- `gitlab.com/VNEU/mf-micro-service-product v0.1.21-release.0.20230721024742-18b8188263f1`

Test files:
- `mf-micro-service-sales/test/app_test.go`
- `mf-micro-service-sales/test/auth_test.go`
- `mf-micro-service-sales/test/configuration_test.go`
- `mf-micro-service-sales/test/controller_test.go`
- `mf-micro-service-sales/test/custom_validator_test.go`
- `mf-micro-service-sales/test/error_handler_test.go`
- `mf-micro-service-sales/test/helper_test.go`
- `mf-micro-service-sales/test/model_test.go`
- `mf-micro-service-sales/test/operator_test.go`
- `mf-micro-service-sales/test/repository_test.go`
- `mf-micro-service-sales/test/route_test.go`
- `mf-micro-service-sales/test/service_test.go`
- `mf-micro-service-sales/test/tx_test.go`

## mf-micro-service-structure

Module: `gitlab.com/VNEU/mf-micro-service-structure`.

Internal dependencies (go.mod):
- `gitlab.com/VNEU/mf-micro-service-city v0.1.8-release.0.20230630081354-80fdf541c02b`
- `gitlab.com/VNEU/mf-micro-service-customer v0.1.8-release.0.20230815010900-8fb2d0efd1dd`
- `gitlab.com/VNEU/mf-micro-service-discount-proposal v0.4.92-release.0.20260408073146-1e3cdbce0765`
- `gitlab.com/VNEU/mf-micro-service-marketing-user v0.1.6-release`
- `gitlab.com/VNEU/mf-micro-service-outlet-2 v0.1.20-m-5`
- `gitlab.com/VNEU/mf-micro-service-sales v0.1.9-m.0.20240228063052-4e49d5acbac7`
- `gitlab.com/vneu/go-helper v0.2.17-rc`
- `gitlab.com/VNEU/mf-micro-service-bank v0.1.13-m.0.20240308070357-e378b42391d5`
- `gitlab.com/VNEU/mf-micro-service-distributor v0.1.8-release.0.20230614012329-a4a68f331197`
- `gitlab.com/VNEU/mf-micro-service-event v0.1.9-release.0.20230803011316-49f9c085989d`
- `gitlab.com/VNEU/mf-micro-service-master-document-proposal v0.1.10-release`
- `gitlab.com/VNEU/mf-micro-service-product v0.1.21-release.0.20230721024742-18b8188263f1`

Test files:
- `mf-micro-service-structure/helper/operator_test.go`
- `mf-micro-service-structure/test/controller_test.go`
- `mf-micro-service-structure/test/domain_test.go`
- `mf-micro-service-structure/test/exception_test.go`
- `mf-micro-service-structure/test/helper_test.go`
- `mf-micro-service-structure/test/main_test.go`
- `mf-micro-service-structure/test/repository_test.go`
- `mf-micro-service-structure/test/route_app_test.go`
- `mf-micro-service-structure/test/service_mock_test.go`
- `mf-micro-service-structure/test/service_test.go`

## rest-api-pondasi-mftl

Module: `GOPONDASI`.

Internal dependencies (go.mod):
- `gitlab.com/vneu/go-helper v0.2.17-rc`

Test files: none observed.

## ski-api-gateway

Module: `gitlab.com/VNEU/ski-api-gateway`.

Internal dependencies (go.mod):
- None declared.

Test files:
- `ski-api-gateway/test/app_test.go`
- `ski-api-gateway/test/auth_test.go`
- `ski-api-gateway/test/config_test.go`
- `ski-api-gateway/test/exception_test.go`
- `ski-api-gateway/test/helper_test.go`
- `ski-api-gateway/test/main_test.go`
- `ski-api-gateway/test/model_test.go`

## ski-compliance-api-warehouse

Module: `gitlab.com/VNEU/ski-compliance-api-warehouse`.

Internal dependencies (go.mod):
- `gitlab.com/VNEU/go-helper v0.5.4`

Test files:
- `ski-compliance-api-warehouse/helper/operator_test.go`
- `ski-compliance-api-warehouse/repository/call_pareto_repository_test.go`

## visit-flow-api-synchronize-ski-compliance

Module: `gitlab.com/VNEU/visit-flow-api-synchronize-ski-compliance`.

Internal dependencies (go.mod):
- `gitlab.com/VNEU/go-helper v0.5.11`
- `gitlab.com/VNEU/logger v0.0.13-m`
- `gitlab.com/VNEU/visit-flow-api-gateway v0.0.99-release.0.20251112004453-2eed824b3186`
- `gitlab.com/VNEU/visit-flow-go v0.1.88-release`

Test files:
- `visit-flow-api-synchronize-ski-compliance/helper/model_test.go`
- `visit-flow-api-synchronize-ski-compliance/helper/operator_test.go`
