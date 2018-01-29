**MarketplaceCore Database - CHANGE-LOG**

- For new patches use the next consecutive **patch number** from the list

**IMPORTANT: USE ONLY [PatchDBTool](https://github.com/IUNO-TDM/PatchDBTool/tree/master/PatchDBTool) to deploy Patches**

|**Patchname**                                                      |**Patch number**   |**Description**                                                                                        |**Issue Number**   | **Author**                  |
|-------------------------------------------------------------------|-------------------|-------------------------------------------------------------------------------------------------------|-------------------|-----------------------------|
| 01_iuno_marketplacecore_VinitialV_20170914.sql                    | Initial version   | Initial patch after deploying DB from Master Branch. Create Patches table.                            |  [#54][i54]       | [@gomarcel][igomarcel]      |
| iuno_marketplacecore_V0001V_20170915.sql                          | 0001              | Update the SetTechnologyData and CreateTechnologyData functions. Error due to ' in TechnologyDataName |  [#91][i91]       | [@gomarcel][igomarcel]      |
| iuno_marketplacecore_V0002V_20170915.sql                          | 0002              | Updated Functions getmostusedcomponents, getworkloadsince, getactivatedlicensessince                  |  [#35][i35]       | [@gomarcel][igomarcel]      |
| iuno_marketplacecore_V0003V_20170920.sql                          | 0003              | Update SetTechnologyData, split Update from Create                                                    |  [#36][i36],[#110][i110],[#111][i111]       | [@gomarcel][igomarcel]      |
| iuno_marketplacecore_V0004V_20170925.sql                          | 0004              | Fix function GetTechnologyByName due to "Ambiguous Column" problem                                    |  [#115][i115]     | [@gomarcel][igomarcel]      |
| iuno_marketplacecore_V0005V_20170928.sql                          | 0005              | Fix function GetTechnologyDataByName due to "Ambiguous Column" problem                                |  [#112][i112]     | [@gomarcel][igomarcel]      |
| iuno_marketplacecore_V0006V_20171010.sql                          | 0006              | Delete unique constraint on the technologydataname                                                    |  [#116][i116]     | [@gomarcel][igomarcel]      |
| iuno_marketplacecore_V0007V_20171107.sql                          | 0007              | Delete old reports functions                                                                          |  [#103][i103]     | [@gomarcel][igomarcel]      |
| iuno_marketplacecore_V0008V_20171107.sql                          | 0008              | Create new functions for report                                                                       |  [#103][i103]       | [@gomarcel][igomarcel]      |
| iuno_marketplacecore_V0009V_20171113.sql                          | 0009              | Fix Bug in function GetTechnologyDataByParams                                                         |  [#120][i120]       | [@gomarcel][igomarcel]      |
| iuno_marketplacecore_V0010V_20171113.sql                          | 0010              | At the moment is not possible to save the imgref on the database                                      |  [#101][i101]       | [@gomarcel][igomarcel]      |
| iuno_marketplacecore_V0011V_20171122.sql                          | 0011              | Fix Bug in function GetTechnologyDataByParams                                                         |  [#131][i131]       | [@gomarcel][igomarcel]      |
| iuno_marketplacecore_V0012V_20171207.sql                          | 0012              | Create new function GetActivatedLicensesCountForUser                                                  |  [#135][i135]       | [@gomarcel][igomarcel]      |
| iuno_marketplacecore_V0013V_20171213.sql                          | 0013              | Update SetComponent and GetTechnologyDataByParams                                                     |  [#138][i138]       | [@gomarcel][igomarcel]      |
| iuno_marketplacecore_V0014V_20171218.sql                          | 0014              | Remove conversion from satoshi to bitcoin from all functions (getrevenue, getrevenuehistory, getrevenueperdayforuser, gettechnologydatahistory, gettoptechnologydata, gettotalrevenue, gettotaluserrevenue)           |  [#141][i141]       | [@gomarcel][igomarcel]      |
| iuno_marketplacecore_V0015V_20180108.sql                          | 0015              | Update DeleteTechnologyData - It has to be proof if the user is allowed to do it.                     |  [#127][i127]       | [@gomarcel][igomarcel]      |
| iuno_marketplacecore_V0016V_20180110.sql                          | 0016              | Fix Sql Injection Issue in CreateLog Function                                                         |  [#144][i144]       | [@gomarcel][igomarcel]      |
| iuno_marketplacecore_V0017V_20180111.sql                          | 0017              | Corrected return value (int -> bigint) for diverse functions                                          |                     | [@gomarcel][igomarcel]      |
| iuno_marketplacecore_V0018V_20180122.sql                          | 0018              | Fixes #149: Distinguish between useruuid and clientuuid in offerrequest                               |  [#149][i149]       | [@mbeuttler][imbeuttler]      |
| iuno_marketplacecore_V0019V_20180122.sql                          | 0019              | Fixes #110: Delete role permissions for diverse functions                                             |  [#110][i110w]       | [@gomarcel][igomarcel]      |
| iuno_marketplacecore_V0020V_20180122.sql                          | 0020              | Fixes #111: Drop unsed or unnecessary functions                                                       |  [#111][i111w]       | [@gomarcel][igomarcel]      |
| iuno_marketplacecore_V0021V_20180124.sql                          | 0021              | Drop function GetOfferForTicket as well as the column TicketId in the Table LicenseOrder. Update CreateLicenseOrder function |  [#148][i148]       | [@gomarcel][igomarcel]      |

[i54]: https://github.com/IUNO-TDM/MarketplaceCore/issues/54
[i91]: https://github.com/IUNO-TDM/MarketplaceCore/issues/91
[i35]: https://github.com/IUNO-TDM/MarketplaceCore/issues/35
[i36]: https://github.com/IUNO-TDM/MarketplaceCore/issues/36
[i101]: https://github.com/IUNO-TDM/MarketplaceCore/issues/101
[i103]: https://github.com/IUNO-TDM/MarketplaceCore/issues/103
[i110]: https://github.com/IUNO-TDM/MarketplaceCore/issues/110
[i110w]: https://github.com/IUNO-TDM/JuiceMarketplaceWebsite/issues/110
[i111w]: https://github.com/IUNO-TDM/JuiceMarketplaceWebsite/issues/111
[i111]: https://github.com/IUNO-TDM/MarketplaceCore/issues/111
[i112]: https://github.com/IUNO-TDM/MarketplaceCore/issues/112
[i115]: https://github.com/IUNO-TDM/MarketplaceCore/issues/115
[i116]: https://github.com/IUNO-TDM/MarketplaceCore/issues/116
[i120]: https://github.com/IUNO-TDM/MarketplaceCore/issues/120
[i127]: https://github.com/IUNO-TDM/MarketplaceCore/issues/127
[i131]: https://github.com/IUNO-TDM/MarketplaceCore/issues/131
[i135]: https://github.com/IUNO-TDM/MarketplaceCore/issues/135
[i138]: https://github.com/IUNO-TDM/MarketplaceCore/issues/138
[i141]: https://github.com/IUNO-TDM/MarketplaceCore/issues/141
[i144]: https://github.com/IUNO-TDM/MarketplaceCore/issues/144
[i148]: https://github.com/IUNO-TDM/MarketplaceCore/issues/148
[i149]: https://github.com/IUNO-TDM/MarketplaceCore/issues/149


[igomarcel]: https://github.com/gomarcel
[imbeuttler]: https://github.com/MBeuttler