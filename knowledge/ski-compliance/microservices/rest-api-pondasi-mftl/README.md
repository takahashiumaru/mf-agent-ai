# rest-api-pondasi-mftl

Legacy foundation API for marketing, finance, HR, manufacturing, master data, imports and SKI warehouse integrations. Handlers are organized by business area under Resource/.

## Table of Contents

- [Overview and architecture](#overview-and-architecture)
- [Technology stack](#technology-stack)
- [Directory structure](#directory-structure)
- [Getting started](#getting-started)
- [Complete API endpoint reference](#complete-api-endpoint-reference)
- [Database and integration notes](#database-and-integration-notes)
- [Quality and deployment](#quality-and-deployment)

## Overview and architecture

`main.go` opens database handles, registers paths on `Auth.CustomMux`, then wraps the mux with CORS and serves on `:8080`. `Resource/` contains the domain handlers. `CustomMux.ServeHTTP` applies its middleware to the mux at request time, including handlers registered before `RegisterMiddleware`. Method restrictions live inside handlers; `Handle` itself does not constrain the HTTP method.

## Technology stack

- Module: `GOPONDASI`.
- Go language version declared by [go.mod](go.mod): **1.19**.
- Gin: `v1.9.1`.
- GORM: `v1.25.2`.
- GORM MySQL driver: `v1.5.1`.
- Validator: `v10.14.1`.
- Viper: `v1.16.0`.
- CORS: `v1.7.0`.

Internal/private modules are pinned in `go.mod`; access to those module versions is required. A sibling checkout does not automatically replace a pinned dependency.

## Directory structure

| Path | Purpose |
| --- | --- |
| [auth/](auth/) | Local authentication helpers; routes may import another module instead |
| [Auth/](Auth/) | Custom mux and authentication |
| [Config/](Config/) | Database/configuration integration |
| [Resource/](Resource/) | Business-area HTTP handlers |

## Getting started

1. Install the Go version required by `go.mod` and configure access to private module dependencies.
2. Prepare local configuration from the loader below. Obtain secrets through the approved secret-management process; do not copy production credentials into README examples.
3. Use an isolated development database and review bootstrap/integration side effects before starting the application.
4. Run from the repository root:

```sh
go mod download
go run .
```

These are documented commands, not commands executed during this README refresh.

### Configuration

Loader: [Config/configuration.go](Config/configuration.go).
The loader reads `Config/.env`. The HTTP listener in `main.go` is `:8080`; database settings are consumed by `Config/`.

Declared configuration keys (names only):

| Key |
| --- |
| `PUB_HOST_DB` |
| `PUB_PASSWORD_DB` |
| `PUB_PORT_DB` |
| `PUB_USER_DB` |
| `PUB_DATABASE_DB` |
| `LOC_HOST_DB` |
| `LOC_PASSWORD_DB` |
| `LOC_PORT_DB` |
| `LOC_USER_DB` |
| `LOC_DATABASE_DB` |
| `RMP_HOST_DB` |
| `RMP_PASSWORD_DB` |
| `RMP_PORT_DB` |
| `RMP_USER_DB` |
| `RMP_DATABASE_DB` |
| `SKI_HOST_DB` |
| `SKI_PASSWORD_DB` |
| `SKI_PORT_DB` |
| `SKI_USER_DB` |
| `SKI_DATABASE_DB` |
| `FTP_MBSBL_ADDR` |
| `FTP_MBSBL_USER` |
| `FTP_MBSBL_PASSWORD` |


## Complete API endpoint reference

**324 source declarations** are listed below, including declarations not called by the current router. Paths preserve the source spelling and parameters. This inventory describes the local checkout, not a verified deployed API.

All entries use mux registration, so their method column is **handler-defined**. Inspect the linked handler for supported methods and payloads. Global authorization is implemented in `Auth/Login.go`: `/login`, `/AiAbsen`, `/presences`, `/SyncAiAbsen`, and `GET /Supplier` have explicit bypass branches; other paths follow the API-key/JWT logic. This does not imply those bypass paths are all registered.

### Main

Source: [main.go](main.go).

| Method | Path | Handler | Source |
| --- | --- | --- | --- |
| Handler-defined | `/importStockPVBL` | `Marketing.ImportStockPVBL(dbPuc, dbSki)` | [L44](main.go#L44) |
| Handler-defined | `/importStockMBSBL` | `Marketing.ImportStockMBSBL(dbPuc, dbSki)` | [L45](main.go#L45) |
| Handler-defined | `/importStockMPI` | `Marketing.ImportStockMPI(dbPuc, dbSki)` | [L46](main.go#L46) |
| Handler-defined | `/importSalesMBSBL` | `Marketing.ImportSalesMBSBL(dbPuc, dbSki)` | [L47](main.go#L47) |
| Handler-defined | `/importSalesMPI` | `Marketing.ImportSalesMPI(dbPuc, dbSki)` | [L48](main.go#L48) |
| Handler-defined | `/importSalesPVBL` | `Marketing.ImportSalesPVBL(dbPuc, dbSki)` | [L49](main.go#L49) |
| Handler-defined | `/update-ski-payment` | `Marketing.SkiPayment(dbLoc)` | [L50](main.go#L50) |
| Handler-defined | `/index` | `Auth.HandlerIndex` | [L54](main.go#L54) |
| Handler-defined | `/login` | `Auth.HandlerLogin(dbPuc)` | [L55](main.go#L55) |
| Handler-defined | `/GeneralExec` | `General.GeneralExec(dbPuc)` | [L57](main.go#L57) |
| Handler-defined | `/CloseSleep` | `General.CloseSleep(dbPuc)` | [L58](main.go#L58) |
| Handler-defined | `/GeneralQuery` | `General.GeneralQuery(dbPuc)` | [L59](main.go#L59) |
| Handler-defined | `/AutoApprovalSKIHeader` | `General.AutoApprovalSKIHeader(dbPuc)` | [L61](main.go#L61) |
| Handler-defined | `/AutoApprovalSKIDetail` | `General.AutoApprovalSKIDetail(dbPuc)` | [L62](main.go#L62) |
| Handler-defined | `/AutoBaseDataMisPlus` | `General.AutoBaseDataMISPlus(dbPuc)` | [L63](main.go#L63) |
| Handler-defined | `/AutoCloseStrukturMKT` | `General.AutoCloseStruktur(dbPuc)` | [L64](main.go#L64) |
| Handler-defined | `/AutoDashboardSKI` | `General.AutoDashboardSKI(dbPuc)` | [L65](main.go#L65) |
| Handler-defined | `/getIncentive` | `Marketing.IncentiveHeader(dbPuc)` | [L67](main.go#L67) |
| Handler-defined | `/getIncentiveDetail` | `Marketing.IncentiveDetail(dbPuc)` | [L68](main.go#L68) |
| Handler-defined | `/IncentiveProcess` | `Marketing.IncentiveProcess(dbPuc)` | [L69](main.go#L69) |
| Handler-defined | `/GetIncentiveHead` | `Marketing.GetIncentiveHead(dbPuc)` | [L70](main.go#L70) |
| Handler-defined | `/GetIncentiveHeadData` | `Marketing.GetIncentiveHeadData(dbPuc)` | [L71](main.go#L71) |
| Handler-defined | `/menu` | `Auth2.Menu(dbPuc)` | [L73](main.go#L73) |
| Handler-defined | `/menuAuth` | `Auth2.MenuAuth(dbPuc)` | [L74](main.go#L74) |
| Handler-defined | `/area` | `Marketing.Area(dbPuc)` | [L76](main.go#L76) |
| Handler-defined | `/user` | `Master.User(dbPuc, dbLoc)` | [L77](main.go#L77) |
| Handler-defined | `/get_user` | `Master.GetUser(dbPuc)` | [L78](main.go#L78) |
| Handler-defined | `/bank` | `Master.Bank(dbPuc)` | [L79](main.go#L79) |
| Handler-defined | `/customer` | `Master.Customer(dbPuc)` | [L80](main.go#L80) |
| Handler-defined | `/customerTL` | `Master.CustomerTL(dbLoc)` | [L81](main.go#L81) |
| Handler-defined | `/getJenisCustomer` | `Master.GetJenisCustomer(dbLoc)` | [L82](main.go#L82) |
| Handler-defined | `/distributor` | `Master.Distributor(dbPuc)` | [L83](main.go#L83) |
| Handler-defined | `/distributorOTC` | `Master.DistributorOTC(dbPuc)` | [L84](main.go#L84) |
| Handler-defined | `/getmenuutamamis` | `Master.MenuUtama(dbPuc)` | [L85](main.go#L85) |
| Handler-defined | `/getmenumis` | `Master.GetMenu(dbPuc)` | [L86](main.go#L86) |
| Handler-defined | `/getsubmenumis` | `Master.GetSubMenu(dbPuc)` | [L87](main.go#L87) |
| Handler-defined | `/getDepartemen` | `Master.GetDepartemen(dbLoc)` | [L88](main.go#L88) |
| Handler-defined | `/unit` | `Master.Unit(dbLoc)` | [L89](main.go#L89) |
| Handler-defined | `/currency` | `Master.Currency(dbLoc)` | [L90](main.go#L90) |
| Handler-defined | `/matgroup` | `Master.MatGroup(dbLoc)` | [L91](main.go#L91) |
| Handler-defined | `/jenis` | `Master.Jenis(dbLoc)` | [L92](main.go#L92) |
| Handler-defined | `/leadtime_po` | `Master.LeadTimePO(dbLoc)` | [L93](main.go#L93) |
| Handler-defined | `/material` | `Master.Material(dbLoc)` | [L94](main.go#L94) |
| Handler-defined | `/vendor` | `Master.Vendor(dbLoc)` | [L95](main.go#L95) |
| Handler-defined | `/karyawan` | `Master.Karyawan(dbLoc)` | [L96](main.go#L96) |
| Handler-defined | `/getSubDepartemen` | `Master.GetSubDepartemen(dbLoc)` | [L97](main.go#L97) |
| Handler-defined | `/getCabang` | `Master.GetCabang(dbLoc)` | [L98](main.go#L98) |
| Handler-defined | `/memberMFTL` | `Master.MemberMFTL(dbLoc)` | [L99](main.go#L99) |
| Handler-defined | `/ProductType` | `Master.ProductType(dbLoc)` | [L100](main.go#L100) |
| Handler-defined | `/ProdukTollIn` | `Master.ProdukTollIn(dbLoc)` | [L101](main.go#L101) |
| Handler-defined | `/JenisProduk` | `Master.JenisProduk(dbLoc)` | [L102](main.go#L102) |
| Handler-defined | `/NomorPerkiraan` | `Master.NomorPerkiraan(dbLoc)` | [L103](main.go#L103) |
| Handler-defined | `/Rate` | `Master.Rate(dbLoc)` | [L104](main.go#L104) |
| Handler-defined | `/GetRateTop1` | `Master.GetRateTop1(dbLoc)` | [L105](main.go#L105) |
| Handler-defined | `/RatePajak` | `Master.RatePajak(dbLoc)` | [L106](main.go#L106) |
| Handler-defined | `/KelompokNeraca` | `Master.KelompokNeraca(dbLoc)` | [L107](main.go#L107) |
| Handler-defined | `/KelompokPerkiraan` | `Master.KelompokPerkiraan(dbLoc)` | [L108](main.go#L108) |
| Handler-defined | `/NomorFakturPajak` | `Master.NomorFakturPajak(dbLoc)` | [L109](main.go#L109) |
| Handler-defined | `/UpdatePelunasanAP` | `Master.UpdatePelunasanAP(dbLoc)` | [L110](main.go#L110) |
| Handler-defined | `/NominalBS` | `Master.NominalBS(dbLoc)` | [L111](main.go#L111) |
| Handler-defined | `/HargaProduct` | `Master.HargaProduct(dbLoc)` | [L112](main.go#L112) |
| Handler-defined | `/TrPenjualan` | `Master.TrPenjualan(dbLoc)` | [L113](main.go#L113) |
| Handler-defined | `/APOnTimeData` | `FA.APOnTimeData(dbLoc)` | [L115](main.go#L115) |
| Handler-defined | `/APOnTimeChart` | `FA.APOnTimeChart(dbLoc)` | [L116](main.go#L116) |
| Handler-defined | `/AROnTimeData` | `FA.AROnTimeData(dbLoc)` | [L117](main.go#L117) |
| Handler-defined | `/AROnTimeChart` | `FA.AROnTimeChart(dbLoc)` | [L118](main.go#L118) |
| Handler-defined | `/document_management` | `Transaksi.DocumentManagement()` | [L120](main.go#L120) |
| Handler-defined | `/pelunasan` | `Transaksi.Pelunasan(dbPuc)` | [L122](main.go#L122) |
| Handler-defined | `/promosi_supportnewCN` | `Transaksi.GetDataSupportCN(dbPuc)` | [L123](main.go#L123) |
| Handler-defined | `/promosi_pelunasannew` | `Transaksi.PelunasanNew(dbPuc)` | [L124](main.go#L124) |
| Handler-defined | `/close_pelunasan` | `Transaksi.CloseCN(dbPuc)` | [L125](main.go#L125) |
| Handler-defined | `/pelunasan_crud` | `Transaksi.PelunasanCRUD(dbPuc)` | [L126](main.go#L126) |
| Handler-defined | `/get_pelunasan` | `Transaksi.GetPelunasan(dbPuc)` | [L127](main.go#L127) |
| Handler-defined | `/get_ski` | `Transaksi.GetSKI(dbPuc)` | [L129](main.go#L129) |
| Handler-defined | `/ClosingData` | `Transaksi.ClosingData(dbLoc)` | [L130](main.go#L130) |
| Handler-defined | `/get_bawahan` | `Master.GetBawahan(dbPuc)` | [L131](main.go#L131) |
| Handler-defined | `/get_ListKolom` | `General.GetList(dbPuc)` | [L133](main.go#L133) |
| Handler-defined | `/input_wo` | `WorkOrder.InputWorkOrder(dbPuc)` | [L135](main.go#L135) |
| Handler-defined | `/get_input_wo` | `WorkOrder.GetInputWO(dbPuc)` | [L136](main.go#L136) |
| Handler-defined | `/signtopic_wo` | `WorkOrder.AddSignToPICWO(dbPuc)` | [L137](main.go#L137) |
| Handler-defined | `/todolist_wo` | `WorkOrder.AddToDoList(dbPuc)` | [L138](main.go#L138) |
| Handler-defined | `/type_wo` | `WorkOrder.TypeWO(dbPuc)` | [L139](main.go#L139) |
| Handler-defined | `/strukturMarketing` | `Marketing.StrukturMarketing(dbPuc)` | [L141](main.go#L141) |
| Handler-defined | `/strukturMarketingEditArea` | `Marketing.EditDataArea(dbPuc)` | [L142](main.go#L142) |
| Handler-defined | `/strukturMarketingPindahArea` | `Marketing.PindahArea(dbPuc)` | [L143](main.go#L143) |
| Handler-defined | `/updateSkiMarketingStructure` | `Marketing.UpdateSkiMarketingStructure(dbPuc, dbSki)` | [L144](main.go#L144) |
| Handler-defined | `/importEstimationAp1` | `Marketing.ImportEstimationAp1(dbSki)` | [L146](main.go#L146) |
| Handler-defined | `/importEstimationAp2` | `Marketing.ImportEstimationAp2(dbSki)` | [L147](main.go#L147) |
| Handler-defined | `/importSalesAPL` | `Marketing.ImportSalesAPL(dbPuc)` | [L149](main.go#L149) |
| Handler-defined | `/importSalesDAD` | `Marketing.ImportSalesDAD(dbPuc, dbSki)` | [L150](main.go#L150) |
| Handler-defined | `/importSalesBMB` | `Marketing.ImportSalesBMB(dbPuc, dbSki)` | [L151](main.go#L151) |
| Handler-defined | `/importSalesENGGAL` | `Marketing.ImportSalesENGGAL(dbPuc, dbSki)` | [L152](main.go#L152) |
| Handler-defined | `/importSalesMPI2` | `Marketing.ImportSalesMPI2(dbPuc, dbSki)` | [L153](main.go#L153) |
| Handler-defined | `/importSalesPVBL2` | `Marketing.ImportSalesPVBL2(dbPuc, dbSki)` | [L154](main.go#L154) |
| Handler-defined | `/importSalesSWS` | `Marketing.ImportSalesSWS(dbPuc, dbSki)` | [L155](main.go#L155) |
| Handler-defined | `/importSalesMALK` | `Marketing.ImportSalesMALK(dbPuc)` | [L156](main.go#L156) |
| Handler-defined | `/importSalesMETISKA` | `Marketing.ImportSalesMETISKA(dbPuc, dbSki)` | [L157](main.go#L157) |
| Handler-defined | `/importSalesEPM` | `Marketing.ImportSalesEPM(dbPuc, dbSki)` | [L158](main.go#L158) |
| Handler-defined | `/importSalesAMS` | `Marketing.ImportSalesAMS(dbPuc, dbSki)` | [L159](main.go#L159) |
| Handler-defined | `/importSalesAMS2` | `Marketing.ImportSalesAMS2(dbPuc, dbSki)` | [L160](main.go#L160) |
| Handler-defined | `/importSalesCOMBI` | `Marketing.ImportSalesCOMBI(dbPuc, dbSki)` | [L161](main.go#L161) |
| Handler-defined | `/stockMisplus` | `Marketing.StockMisplus(dbPuc)` | [L162](main.go#L162) |
| Handler-defined | `/importStockDAD` | `Marketing.ImportStockDAD(dbPuc, dbSki)` | [L163](main.go#L163) |
| Handler-defined | `/importStockSWS` | `Marketing.ImportStockSWS(dbPuc, dbSki)` | [L164](main.go#L164) |
| Handler-defined | `/importTarget` | `Marketing.ImportTargetMisplus(dbPuc, dbSki)` | [L165](main.go#L165) |
| Handler-defined | `/importSalesMPIotc` | `Marketing.ImportSalesMPIotc(dbPuc)` | [L167](main.go#L167) |
| Handler-defined | `/importSalesMPI2otc` | `Marketing.ImportSalesMPI2otc(dbPuc, dbSki)` | [L168](main.go#L168) |
| Handler-defined | `/importSalesPVBLotc` | `Marketing.ImportSalesPVBLotc(dbPuc)` | [L169](main.go#L169) |
| Handler-defined | `/importSalesPVBL2otc` | `Marketing.ImportSalesPVBL2otc(dbPuc, dbSki)` | [L170](main.go#L170) |
| Handler-defined | `/importSalesMBSBL2otc` | `Marketing.ImportSalesMBSBL2otc(dbPuc, dbSki)` | [L171](main.go#L171) |
| Handler-defined | `/importSalesAMSotc` | `Marketing.ImportSalesAMSotc(dbPuc)` | [L172](main.go#L172) |
| Handler-defined | `/importSalesAMS2otc` | `Marketing.ImportSalesAMS2otc(dbPuc, dbSki)` | [L173](main.go#L173) |
| Handler-defined | `/importSalesMJSotc` | `Marketing.ImportSalesMJSotc(dbPuc)` | [L174](main.go#L174) |
| Handler-defined | `/importSalesCMAotc` | `Marketing.ImportSalesCMAotc(dbPuc)` | [L175](main.go#L175) |
| Handler-defined | `/importSalesDMotc` | `Marketing.ImportSalesDMotc(dbPuc)` | [L176](main.go#L176) |
| Handler-defined | `/importTargetOTC` | `Marketing.ImportTargetOTC(dbPuc)` | [L177](main.go#L177) |
| Handler-defined | `/syncTargetOTCWH` | `Marketing.SyncTargetOTC(dbPuc, dbSki)` | [L178](main.go#L178) |
| Handler-defined | `/LaporanSalesPertahun` | `Marketing.LaporanSalesPertahun(dbPuc)` | [L179](main.go#L179) |
| Handler-defined | `/LaporanSalesUserPertahun` | `Marketing.LaporanSalesUserPertahun(dbPuc)` | [L180](main.go#L180) |
| Handler-defined | `/LaporanSalesProdukPertahun` | `Marketing.LaporanSalesProdukPertahun(dbPuc)` | [L181](main.go#L181) |
| Handler-defined | `/LaporanSalesOutletPertahun` | `Marketing.LaporanSalesOutletPertahun(dbPuc)` | [L182](main.go#L182) |
| Handler-defined | `/LaporanSalesCallPertahun` | `Marketing.LaporanSalesCallPertahun(dbPuc)` | [L183](main.go#L183) |
| Handler-defined | `/MasterJabatan` | `Marketing.MasterJabatan(dbPuc)` | [L184](main.go#L184) |
| Handler-defined | `/MasterKodeFF` | `Marketing.MasterKodeFF(dbPuc)` | [L185](main.go#L185) |
| Handler-defined | `/MasterPeriodeSales` | `Marketing.MasterPeriodeSales(dbPuc)` | [L186](main.go#L186) |
| Handler-defined | `/MasterCustomer` | `Marketing.MasterCustomer(dbPuc)` | [L187](main.go#L187) |
| Handler-defined | `/protapNC` | `QCQA.ProtapNC(dbLoc)` | [L189](main.go#L189) |
| Handler-defined | `/updateStatusNC` | `QCQA.UpdateStatusNC(dbLoc)` | [L190](main.go#L190) |
| Handler-defined | `/updateStatusNCpair` | `QCQA.UpdateStatusNCpair(dbLoc)` | [L191](main.go#L191) |
| Handler-defined | `/protapSpesifikasi` | `QCQA.ProtapSpesifikasi(dbLoc)` | [L192](main.go#L192) |
| Handler-defined | `/approvalDeptQA` | `QCQA.ApprovalDeptQA(dbLoc)` | [L193](main.go#L193) |
| Handler-defined | `/updateStatusPS` | `QCQA.UpdateStatusPS(dbLoc)` | [L194](main.go#L194) |
| Handler-defined | `/TipeSpesifikasi` | `QCQA.TipeSpesifikasi(dbLoc)` | [L195](main.go#L195) |
| Handler-defined | `/jobsheetproduct` | `jobsheet.GetJobSheetProduct(dbLoc)` | [L197](main.go#L197) |
| Handler-defined | `/importForecast` | `Marketing.ImportForecast(dbLoc)` | [L198](main.go#L198) |
| Handler-defined | `/checkClaimDiscount` | `Marketing.GetCheckClaimDiscount(dbPuc)` | [L200](main.go#L200) |
| Handler-defined | `/QRCode` | `jobsheet.QRCode(dbLoc)` | [L201](main.go#L201) |
| Handler-defined | `/product` | `Master.Product(dbLoc)` | [L202](main.go#L202) |
| Handler-defined | `/produksi/line` | `Master.ProduksiLine(dbLoc)` | [L203](main.go#L203) |
| Handler-defined | `/divisi` | `Master.Divisi(dbLoc)` | [L204](main.go#L204) |
| Handler-defined | `/prodJenis` | `Master.ProdJenis(dbLoc)` | [L205](main.go#L205) |
| Handler-defined | `/unitProd` | `Master.UnitProd(dbLoc)` | [L206](main.go#L206) |
| Handler-defined | `/produksi/report-manhour` | `Produksi.ReportManhour(dbLoc)` | [L208](main.go#L208) |
| Handler-defined | `/get_approvalSKI_header` | `Marketing.Get_DataSKI(dbPuc)` | [L210](main.go#L210) |
| Handler-defined | `/get_approvalSKI_detail_cust` | `Marketing.Get_DataSKIDetailSKI(dbPuc)` | [L211](main.go#L211) |
| Handler-defined | `/get_approvalSKI_detail_ski` | `Marketing.Get_DataSKIDetailSKI2(dbPuc)` | [L212](main.go#L212) |
| Handler-defined | `/get_approvalSKI_detail_ski_det` | `Marketing.Get_DataSKIDetailSKI2_detail(dbPuc)` | [L213](main.go#L213) |
| Handler-defined | `/get_approvalSKI_detail_ski_fokus` | `Marketing.Get_DataSKIDetailSKI3(dbPuc)` | [L214](main.go#L214) |
| Handler-defined | `/get_approvalSKI_detail_ski_nonfokus` | `Marketing.Get_DataSKIDetailSKI3_nonfokus(dbPuc)` | [L215](main.go#L215) |
| Handler-defined | `/get_approvalSKI_detail_ski_outlet` | `Marketing.Get_DataSKIDetailSKI3_apotik(dbPuc)` | [L216](main.go#L216) |
| Handler-defined | `/get_approvalSKI_detail_ski_K4` | `Marketing.Get_DataSKIDetailSKI_K4(dbPuc)` | [L217](main.go#L217) |
| Handler-defined | `/get_approvalSKI_detail_rekomendasi` | `Marketing.Get_DataSKIDetailSKI_Rekomendasi(dbPuc)` | [L218](main.go#L218) |
| Handler-defined | `/get_approvalSKI_act_approve` | `Marketing.Approve_SKI_Final(dbPuc)` | [L219](main.go#L219) |
| Handler-defined | `/get_new_approvalSKI_editQtyDisc` | `Marketing.NewGetApprovalSKIEditQtyDisc(dbPuc)` | [L220](main.go#L220) |
| Handler-defined | `/get_new_approvalSKI_head` | `Marketing.NewGetApprovalSKIHead(dbPuc)` | [L222](main.go#L222) |
| Handler-defined | `/get_new_approvalSKI_detail` | `Marketing.NewGetApprovalSKIDetail(dbPuc)` | [L223](main.go#L223) |
| Handler-defined | `/get_mcl_cov` | `Marketing.GetMCLCOV(dbPuc)` | [L225](main.go#L225) |
| Handler-defined | `/get_KPIcorporate` | `KPI.GetKPIcorporate(dbLoc)` | [L227](main.go#L227) |
| Handler-defined | `/get_KPISalesIN` | `KPI.GetKPISalesIN(dbLoc)` | [L228](main.go#L228) |
| Handler-defined | `/get_KPISalesOut` | `KPI.GetKPISalesOut(dbPuc)` | [L229](main.go#L229) |
| Handler-defined | `/get_KPIAllGM` | `KPI.GetKPIALLGM(dbPuc, dbLoc)` | [L230](main.go#L230) |
| Handler-defined | `/get_KPIEthical` | `KPI.GetKPIEthical(dbPuc)` | [L231](main.go#L231) |
| Handler-defined | `/get_KPIOTC` | `KPI.GetKPIOTC(dbPuc)` | [L232](main.go#L232) |
| Handler-defined | `/Dashboard` | `dashboard.Dashboard(dbPuc)` | [L234](main.go#L234) |
| Handler-defined | `/AreaFar` | `Marketing.AreaFar(dbPuc)` | [L235](main.go#L235) |
| Handler-defined | `/Struktur` | `Marketing.Struktur(dbPuc)` | [L236](main.go#L236) |
| Handler-defined | `/DiscountProposalConfirm` | `Marketing.DiscountProposalConfirm(dbPuc)` | [L237](main.go#L237) |
| Handler-defined | `/DiscountProposalUpdateStatus` | `Marketing.DiscountProposalUpdateStatus(dbPuc)` | [L238](main.go#L238) |
| Handler-defined | `/CallMarketing` | `Marketing.CallMarketing(dbPuc)` | [L239](main.go#L239) |
| Handler-defined | `/CallMarketingGet` | `Marketing.CallMarketingGet(dbPuc)` | [L240](main.go#L240) |
| Handler-defined | `/CallMarketingInsert` | `Marketing.CallMarketingInsert(dbPuc)` | [L241](main.go#L241) |
| Handler-defined | `/CallMarketingTarget` | `Marketing.CallMarketingTarget(dbPuc)` | [L242](main.go#L242) |
| Handler-defined | `/CallMarketingTargetInsert` | `Marketing.CallMarketingTargetInsert(dbPuc)` | [L243](main.go#L243) |
| Handler-defined | `/CallMarketingTargetUpdate` | `Marketing.CallMarketingTargetUpdate(dbPuc)` | [L244](main.go#L244) |
| Handler-defined | `/CallMarketingActualProductGet` | `Marketing.CallMarketingActualProductGet(dbPuc)` | [L245](main.go#L245) |
| Handler-defined | `/CallMarketingActualProductInsert` | `Marketing.CallMarketingActualProductInsert(dbPuc)` | [L246](main.go#L246) |
| Handler-defined | `/CallMarketingHistoryDetail` | `Marketing.CallMarketingHistoryDetail(dbPuc)` | [L247](main.go#L247) |
| Handler-defined | `/DiscountProposalDist` | `Marketing.DiscountProposalDist(dbPuc)` | [L248](main.go#L248) |
| Handler-defined | `/DiscountProposalDistInsert` | `Marketing.DiscountProposalDistInsert(dbPuc)` | [L249](main.go#L249) |
| Handler-defined | `/UserSKIActive` | `Marketing.UserSKIActive(dbPuc)` | [L250](main.go#L250) |
| Handler-defined | `/IncentiveFar` | `Marketing.IncentiveFar(dbPuc)` | [L251](main.go#L251) |
| Handler-defined | `/MCLRealisasiLbb` | `Marketing.MCLRealisasiLbb(dbPuc)` | [L252](main.go#L252) |
| Handler-defined | `/MCLRealisasiLbbInsert` | `Marketing.MCLRealisasiLbbInsert(dbPuc)` | [L253](main.go#L253) |
| Handler-defined | `/AnalisaTargetVsSales` | `Marketing.AnalisaTargetVsSales(dbPuc)` | [L254](main.go#L254) |
| Handler-defined | `/AnalisaTargetVsSalesProses` | `Marketing.AnalisaTargetVsSalesProses(dbPuc)` | [L255](main.go#L255) |
| Handler-defined | `/CallMarketingActual_insert_product` | `Marketing.CallMarketingActual_insert_product(dbPuc)` | [L256](main.go#L256) |
| Handler-defined | `/ApproveDLDFOTC` | `Marketing.ApproveDLDFOTC(dbPuc)` | [L257](main.go#L257) |
| Handler-defined | `/ApproveDLDFOTCDetail` | `Marketing.ApproveDLDFOTCDetail(dbPuc)` | [L258](main.go#L258) |
| Handler-defined | `/ApproveDLDFOTCDetailData` | `Marketing.ApproveDLDFOTCDetailData(dbPuc)` | [L259](main.go#L259) |
| Handler-defined | `/ApproveDLDFOTCReject` | `Marketing.ApproveDLDFOTCReject(dbPuc)` | [L260](main.go#L260) |
| Handler-defined | `/DetailPenerima` | `Marketing.DetailPenerima(dbPuc)` | [L261](main.go#L261) |
| Handler-defined | `/DetailPenerimaSKI` | `Marketing.DetailPenerimaSKI(dbPuc)` | [L262](main.go#L262) |
| Handler-defined | `/RekCustomer` | `Marketing.RekCustomer(dbPuc)` | [L263](main.go#L263) |
| Handler-defined | `/RekBO` | `Marketing.RekBO(dbPuc)` | [L264](main.go#L264) |
| Handler-defined | `/SKIDetail` | `Marketing.SKIDetail(dbPuc)` | [L265](main.go#L265) |
| Handler-defined | `/Pelunasan` | `Marketing.Pelunasan(dbPuc)` | [L266](main.go#L266) |
| Handler-defined | `/SKIInput` | `Marketing.SKIInput(dbPuc)` | [L267](main.go#L267) |
| Handler-defined | `/DLDFInput` | `Marketing.InputDLDF(dbPuc)` | [L268](main.go#L268) |
| Handler-defined | `/DLDFConfirm` | `Marketing.ConfirmInputDLDF(dbPuc)` | [L269](main.go#L269) |
| Handler-defined | `/DLDFTerminate` | `Marketing.TerminateInputDLDF(dbPuc)` | [L270](main.go#L270) |
| Handler-defined | `/DLDFInputDetail` | `Marketing.InputDLDFDetail(dbPuc)` | [L271](main.go#L271) |
| Handler-defined | `/DLDFInputDataDetail` | `Marketing.InputDLDFDataDetail(dbPuc)` | [L272](main.go#L272) |
| Handler-defined | `/DLDFInputDataDetailAddNol` | `Marketing.InputDLDFDataDetailAddNol(dbPuc)` | [L273](main.go#L273) |
| Handler-defined | `/DashboardCustomerSKI` | `Marketing.GetDashCustomer(dbPuc)` | [L275](main.go#L275) |
| Handler-defined | `/DashboardCustomerSKIChart` | `Marketing.GetDashCustomerChart(dbPuc)` | [L276](main.go#L276) |
| Handler-defined | `/DashboardOutletSKI` | `Marketing.GetDashOutlet(dbPuc)` | [L277](main.go#L277) |
| Handler-defined | `/DashboardOutletSKIChart` | `Marketing.GetDashOutletChart(dbPuc)` | [L278](main.go#L278) |
| Handler-defined | `/DashboardProdukSKI` | `Marketing.GetDashProduk(dbPuc)` | [L279](main.go#L279) |
| Handler-defined | `/DashboardProdukSKIChart` | `Marketing.GetDashProdukChart(dbPuc)` | [L280](main.go#L280) |
| Handler-defined | `/DashboardFFSKI` | `Marketing.GetDashFF(dbPuc)` | [L281](main.go#L281) |
| Handler-defined | `/DashboardFFSKIChart` | `Marketing.GetDashFFChart(dbPuc)` | [L282](main.go#L282) |
| Handler-defined | `/DashboardPieChartCustomer` | `Marketing.GetPieChartCustomer(dbPuc)` | [L283](main.go#L283) |
| Handler-defined | `/DashboardPieChartOutlet` | `Marketing.GetPieChartOutlet(dbPuc)` | [L284](main.go#L284) |
| Handler-defined | `/DashboardPieChartProduk` | `Marketing.GetPieChartProduk(dbPuc)` | [L285](main.go#L285) |
| Handler-defined | `/DashboardPieChartASM` | `Marketing.GetPieChartASM(dbPuc)` | [L286](main.go#L286) |
| Handler-defined | `/get_list_tm` | `Master.TMGet(dbPuc)` | [L288](main.go#L288) |
| Handler-defined | `/get_detail_tm` | `Master.TMget_Detail(dbPuc)` | [L289](main.go#L289) |
| Handler-defined | `/get_tm_listweb` | `Master.TMget_listweb(dbPuc)` | [L290](main.go#L290) |
| Handler-defined | `/insert_productspesialis` | `Master.TMinsert_Maping(dbPuc)` | [L291](main.go#L291) |
| Handler-defined | `/get_tm_pertanyaan` | `Master.TMget_Pertanyaan(dbPuc)` | [L292](main.go#L292) |
| Handler-defined | `/insert_pertanyaan` | `Master.Insert_Pertanyaan(dbPuc)` | [L293](main.go#L293) |
| Handler-defined | `/BawahanFar` | `Master.BawahanFar(dbPuc)` | [L294](main.go#L294) |
| Handler-defined | `/Company` | `Master.Company(dbPuc)` | [L295](main.go#L295) |
| Handler-defined | `/CustomerFar` | `Master.CustomerFar(dbPuc)` | [L296](main.go#L296) |
| Handler-defined | `/Outlet` | `Master.Outlet(dbPuc)` | [L297](main.go#L297) |
| Handler-defined | `/ProductFar` | `Master.ProductFar(dbPuc)` | [L298](main.go#L298) |
| Handler-defined | `/Query` | `Master.Query(dbPuc)` | [L299](main.go#L299) |
| Handler-defined | `/LBBHeader` | `LBB.LBBHeader(dbPuc)` | [L301](main.go#L301) |
| Handler-defined | `/LBBHeaderGetCrud` | `LBB.LBBHeaderGetCrud(dbPuc)` | [L302](main.go#L302) |
| Handler-defined | `/LBBHeaderGetCrudArea` | `LBB.LBBHeaderGetCrudArea(dbPuc)` | [L303](main.go#L303) |
| Handler-defined | `/LBBHeaderGetCrudNama` | `LBB.LBBHeaderGetCrudNama(dbPuc)` | [L304](main.go#L304) |
| Handler-defined | `/LBBHeaderGetCrudRek` | `LBB.LBBHeaderGetCrudRek(dbPuc)` | [L305](main.go#L305) |
| Handler-defined | `/LBBHeaderDelete` | `LBB.LBBHeaderDelete(dbPuc)` | [L306](main.go#L306) |
| Handler-defined | `/LBBDetail` | `LBB.LBBDetail(dbPuc)` | [L307](main.go#L307) |
| Handler-defined | `/LBBDetailInsert` | `LBB.LBBDetailInsert(dbPuc)` | [L308](main.go#L308) |
| Handler-defined | `/LBBDetailInsertBawahan` | `LBB.LBBDetailInsertBawahan(dbPuc)` | [L309](main.go#L309) |
| Handler-defined | `/LBBDetail2` | `LBB.LBBDetail2(dbPuc)` | [L310](main.go#L310) |
| Handler-defined | `/LBBDetail2Insert` | `LBB.LBBDetail2Insert(dbPuc)` | [L311](main.go#L311) |
| Handler-defined | `/LBBDetail2InsertKategoriBiaya` | `LBB.LBBDetail2InsertKategoriBiaya(dbPuc)` | [L312](main.go#L312) |
| Handler-defined | `/TrackingPO` | `POSO.TrackingPO(dbLoc)` | [L314](main.go#L314) |
| Handler-defined | `/InsertPOPbf` | `POSO.InsertPOPbf(dbLoc)` | [L315](main.go#L315) |
| Handler-defined | `/GetPOPbf` | `POSO.GetPOPbf(dbLoc)` | [L316](main.go#L316) |
| Handler-defined | `/EditDataSOHead` | `POSO.EditDataSOHead(dbLoc)` | [L317](main.go#L317) |
| Handler-defined | `/EditPajakSOHead` | `POSO.EditPajakSOHead(dbLoc)` | [L318](main.go#L318) |
| Handler-defined | `/EditDataSODetail` | `POSO.EditDataSODetail(dbLoc)` | [L319](main.go#L319) |
| Handler-defined | `/MaterialSupplier` | `Master.MaterialSupplier(dbLoc)` | [L321](main.go#L321) |
| Handler-defined | `/SupplierBank` | `Master.SupplierBank(dbLoc)` | [L322](main.go#L322) |
| Handler-defined | `/HargaJasaTollIn` | `Master.HargaJasaTollIn(dbLoc)` | [L323](main.go#L323) |
| Handler-defined | `/HargaJasaTollOut` | `Master.HargaJasaTollOut(dbLoc)` | [L324](main.go#L324) |
| Handler-defined | `/CekBatch` | `Master.CekBatch(dbLoc)` | [L325](main.go#L325) |
| Handler-defined | `/SaldoStockProduct` | `Master.SaldoStockProduct(dbLoc)` | [L326](main.go#L326) |
| Handler-defined | `/ProductAch` | `Master.ProductAch(dbLoc)` | [L327](main.go#L327) |
| Handler-defined | `/TypePesanan` | `Master.TypePesanan(dbLoc)` | [L328](main.go#L328) |
| Handler-defined | `/BonusOTC` | `Master.BonusOTC(dbLoc)` | [L329](main.go#L329) |
| Handler-defined | `/DiskonCustomer` | `Master.DiskonCustomer(dbLoc)` | [L330](main.go#L330) |
| Handler-defined | `/Instansi` | `Master.Instansi(dbLoc)` | [L331](main.go#L331) |
| Handler-defined | `/Referensi` | `Master.Referensi(dbLoc)` | [L332](main.go#L332) |
| Handler-defined | `/Supplier` | `Master.Supplier(dbLoc)` | [L333](main.go#L333) |
| Handler-defined | `/VendorMaterial` | `Master.VendorMaterial(dbLoc)` | [L334](main.go#L334) |
| Handler-defined | `/MasterCompany` | `Master.MasterCompany(dbLoc)` | [L335](main.go#L335) |
| Handler-defined | `/MasterCompanyBank` | `Master.MasterCompanyBank(dbLoc)` | [L336](main.go#L336) |
| Handler-defined | `/MasterType` | `Master.MasterType(dbLoc)` | [L337](main.go#L337) |
| Handler-defined | `/DesignKemasan` | `Master.DesignKemasan(dbLoc)` | [L338](main.go#L338) |
| Handler-defined | `/DesignKemasanDetail` | `Master.DesignKemasanDetail(dbLoc)` | [L339](main.go#L339) |
| Handler-defined | `/DesignKemasanVariasi` | `Master.DesignKemasanVariasi(dbLoc)` | [L340](main.go#L340) |
| Handler-defined | `/DesignKemasanConfirmPackDev` | `Master.DesignKemasanConfirmPackDev(dbLoc)` | [L341](main.go#L341) |
| Handler-defined | `/DesignKemasanConfirmAssRND` | `Master.DesignKemasanConfirmAssRND(dbLoc)` | [L342](main.go#L342) |
| Handler-defined | `/DesignKemasanConfirmBussDev` | `Master.DesignKemasanConfirmBussDev(dbLoc)` | [L343](main.go#L343) |
| Handler-defined | `/DesignKemasanConfirmRegulatory` | `Master.DesignKemasanConfirmRegulatory(dbLoc)` | [L344](main.go#L344) |
| Handler-defined | `/DesignKemasanConfirmPurchasing` | `Master.DesignKemasanConfirmPurchasing(dbLoc)` | [L345](main.go#L345) |
| Handler-defined | `/ProductUbahStatus` | `Master.ProductUbahStatus(dbLoc)` | [L346](main.go#L346) |
| Handler-defined | `/JenisAsset` | `Master.JenisAsset(dbLoc)` | [L347](main.go#L347) |
| Handler-defined | `/JenisPerkiraanJurnal` | `Master.JenisPerkiraanJurnal(dbLoc)` | [L348](main.go#L348) |
| Handler-defined | `/KodeHuruf` | `Master.KodeHuruf(dbLoc)` | [L349](main.go#L349) |
| Handler-defined | `/Cuti` | `HRD.Cuti(dbLoc)` | [L351](main.go#L351) |
| Handler-defined | `/CutiDetail` | `HRD.CutiDetail(dbLoc)` | [L352](main.go#L352) |
| Handler-defined | `/CutiAll` | `HRD.CutiAll(dbLoc)` | [L353](main.go#L353) |
| Handler-defined | `/ProsesBatalCuti` | `HRD.ProsesBatalCuti(dbLoc)` | [L354](main.go#L354) |
| Handler-defined | `/DeleteDataCuti` | `HRD.DeleteDataCuti(dbLoc)` | [L355](main.go#L355) |
| Handler-defined | `/LapAbsensiBulanan` | `HRD.LapAbsensiBulanan(dbLoc)` | [L356](main.go#L356) |
| Handler-defined | `/TotalKehadiran` | `HRD.TotalKehadiran(dbLoc)` | [L357](main.go#L357) |
| Handler-defined | `/Hirarki` | `HRD.Hirarki(dbLoc)` | [L358](main.go#L358) |
| Handler-defined | `/CutiKaryawan` | `HRD.CutiKaryawan(dbLoc)` | [L359](main.go#L359) |
| Handler-defined | `/CutiKaryawanDetail` | `HRD.CutiKaryawanDetail(dbLoc)` | [L360](main.go#L360) |
| Handler-defined | `/CutiKaryawanDetailAdd` | `HRD.CutiKaryawanDetailAdd(dbLoc)` | [L361](main.go#L361) |
| Handler-defined | `/CutiKaryawanDetailPrint` | `HRD.CutiKaryawanDetailPrint(dbLoc)` | [L362](main.go#L362) |
| Handler-defined | `/CutiKaryawanDetailConfirm` | `HRD.CutiKaryawanDetailConfirm(dbLoc)` | [L363](main.go#L363) |
| Handler-defined | `/CutiKaryawanDetailBatalCuti` | `HRD.CutiKaryawanDetailBatalCuti(dbLoc)` | [L364](main.go#L364) |
| Handler-defined | `/CutiKaryawanDetailData` | `HRD.CutiKaryawanDetailData(dbLoc)` | [L365](main.go#L365) |
| Handler-defined | `/MasterJenisCuti` | `HRD.MasterJenisCuti(dbLoc)` | [L366](main.go#L366) |
| Handler-defined | `/IzinKaryawan` | `HRD.IzinKaryawan(dbLoc)` | [L367](main.go#L367) |
| Handler-defined | `/IzinKaryawanAdd` | `HRD.IzinKaryawanAdd(dbLoc)` | [L368](main.go#L368) |
| Handler-defined | `/IzinKaryawanEdit` | `HRD.IzinKaryawanEdit(dbLoc)` | [L369](main.go#L369) |
| Handler-defined | `/IzinKaryawanDelete` | `HRD.IzinKaryawanDelete(dbLoc)` | [L370](main.go#L370) |
| Handler-defined | `/IzinKaryawanBatal` | `HRD.IzinKaryawanBatal(dbLoc)` | [L371](main.go#L371) |
| Handler-defined | `/FKAKaryawan` | `HRD.FKAKaryawan(dbLoc)` | [L372](main.go#L372) |
| Handler-defined | `/FKAKaryawanConfirm` | `HRD.FKAKaryawanConfirm(dbLoc)` | [L373](main.go#L373) |
| Handler-defined | `/AiAbsen` | `HRD.AiAbsen(dbPuc, dbLoc)` | [L374](main.go#L374) |
| Handler-defined | `/presences` | `HRD.HistoryAbsen(dbPuc, dbLoc)` | [L375](main.go#L375) |
| Handler-defined | `/SyncAiAbsen` | `HRD.SyncOfflineAbsen(dbPuc, dbLoc)` | [L376](main.go#L376) |
| Handler-defined | `/InputDLDFOTC` | `Marketing.InputDLDFOTC(dbPuc)` | [L378](main.go#L378) |
| Handler-defined | `/PrintDLDFOTC` | `Marketing.PrintDLDFOTC(dbPuc)` | [L379](main.go#L379) |
| Handler-defined | `/ConfirmDLDFOTC` | `Marketing.ConfirmDLDFOTC(dbPuc)` | [L380](main.go#L380) |
| Handler-defined | `/CopyDLOTC` | `Marketing.CopyDLOTC(dbPuc)` | [L381](main.go#L381) |
| Handler-defined | `/InputDLDFOTCDetail` | `Marketing.InputDLDFOTCDetail(dbPuc)` | [L382](main.go#L382) |
| Handler-defined | `/InputDLDFOTCDetailData` | `Marketing.InputDLDFOTCDetailData(dbPuc)` | [L383](main.go#L383) |
| Handler-defined | `/InputDLDFOTCDetailDataNOL` | `Marketing.InputDLDFOTCDetailDataNOL(dbPuc)` | [L384](main.go#L384) |
| Handler-defined | `/JenisTransDLDFOTC` | `Marketing.JenisTransDLDFOTC(dbPuc)` | [L385](main.go#L385) |
| Handler-defined | `/exportDLDFOTC` | `Marketing.ExportXlsDLDFOTC(dbPuc)` | [L386](main.go#L386) |
| Handler-defined | `/Kota_OTC` | `MasterOTC.Kota(dbPuc)` | [L388](main.go#L388) |
| Handler-defined | `/Struktur_OTC` | `MasterOTC.Struktur(dbPuc)` | [L389](main.go#L389) |
| Handler-defined | `/Outlet_OTC` | `MasterOTC.Outlet(dbPuc)` | [L390](main.go#L390) |
| Handler-defined | `/TerriGT_OTC` | `MasterOTC.TerriGT(dbPuc)` | [L391](main.go#L391) |
| Handler-defined | `/ListTerriGTDLDF_OTC` | `MasterOTC.ListTerriGTDLDF(dbPuc)` | [L392](main.go#L392) |
| Handler-defined | `/importTerriGT_OTC` | `MasterOTC.UploadTerriGT(dbPuc)` | [L393](main.go#L393) |
| Handler-defined | `/Product_OTC` | `MasterOTC.Product(dbPuc)` | [L394](main.go#L394) |
| Handler-defined | `/BridgingCustomer` | `MasterOTC.BridgingCustomer(dbPuc)` | [L395](main.go#L395) |
| Handler-defined | `/MasterDiscountRMP` | `MasterRMP.MasterDiscountRMP(dbRMP)` | [L397](main.go#L397) |
| Handler-defined | `/PlatformPengobatan` | `Marketing.PlatformPengobatan(dbPuc)` | [L399](main.go#L399) |
| Handler-defined | `/dw-sales-out` | `Marketing.DWSalesOut(dbPuc)` | [L401](main.go#L401) |
| Handler-defined | `/dw-pelunasan` | `Marketing.DWPelunasan(dbPuc)` | [L402](main.go#L402) |
| Handler-defined | `/dw-call` | `Marketing.DWCall(dbPuc)` | [L403](main.go#L403) |
| Handler-defined | `/dw-ski` | `Marketing.DWSKI(dbPuc)` | [L404](main.go#L404) |
| Handler-defined | `/dw-k4` | `Marketing.DWK4(dbPuc)` | [L405](main.go#L405) |


## Database and integration notes

`Config.Connect()` returns the handles used as `dbPuc`, `dbLoc`, `dbRMP` and `dbSki` in `main.go`. Resource handlers receive the relevant handles explicitly. Review each handler before invoking imports, warehouse jobs or general SQL execution endpoints; these can write data. No production call or schema migration was performed for this documentation.

## Quality and deployment

Useful checks, to run in an appropriate development environment:

```sh
go build ./...
go test ./...
go vet ./...
```

No application tests, service startup, deployment or database mutations were performed for this README update. Existing coverage files or badges are not a fresh coverage measurement.

Container definition: [Dockerfile](Dockerfile). Base stages: `golang:1.19`.

```sh
docker build -t rest-api-pondasi-mftl:local .
```

Review [docker-compose.yml](docker-compose.yml) for environment files, mounts, networks and host port mapping before running Compose.

## Documentation provenance

Updated on 2026-09-27 from the current local source/configuration. The discount-proposal README supplied the section structure; endpoint, version and configuration facts were extracted from this repository. Source declarations and local changes are not deployment verification.
