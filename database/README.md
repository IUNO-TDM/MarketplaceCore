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
| iuno_marketplacecore_V0022V_20180123.sql                          | 0022              | Update all functions due to the checkpermissions update.                                              |                     | [@gomarcel][igomarcel]      |
| iuno_marketplacecore_V0023V_20180123.sql                          | 0023              | Create UserKey table, insert key value for functions, add key and isowner columns to the function table  |                     | [@gomarcel][igomarcel]      |
| iuno_marketplacecore_V0024V_20180208.sql                          | 0024              | Added new column in technologydata table and updated functions to hold background color information    |                     | [@mbeuttler][imbeuttler]      |
| iuno_marketplacecore_V0025V_20180214.sql                          | 0025              | Proof if procedure caller is also data owner or has permissions to do it                               |  [#127][i127]                   | [@gomarcel][igomarcel] |
| iuno_marketplacecore_V0026V_20180219.sql                          | 0026              | Allow Admin users to call any function.                                                                |  [#127][i127]                   | [@gomarcel][igomarcel] |
| iuno_marketplacecore_V0027V_20180219.sql                          | 0027              | Update GetTechnologyDataByParams function.                                                             |  [#127][i127]                   | [@gomarcel][igomarcel] |
| iuno_marketplacecore_V0028V_20180219.sql                          | 0028              | Correct Bug by SetComponent.                                                                           |  [#159][i159]                   | [@gomarcel][igomarcel] |
| iuno_marketplacecore_V0029V_20180219.sql                          | 0029              | Update Get Components function.                                                                        |  [#159][i159]                   | [@gomarcel][igomarcel] |
| iuno_marketplacecore_V0030V_20180313.sql                          | 0030              | Delete old role and permission concept, Create CheckOwnership function, Update CheckPermission function and others. |  [#165][i65]       | [@gomarcel][igomarcel] |
| iuno_marketplacecore_V0031V_20180313.sql                          | 0031              | Update CheckPermissions call in all functions.                                                         |  [#165][i165]                   | [@gomarcel][igomarcel] |
| iuno_marketplacecore_V0032V_20180315.sql                          | 0032              | Create Function CreateProtocols                                                                        |  [#165][i165]                   | [@gomarcel][igomarcel] |
| iuno_marketplacecore_V0033V_20180320.sql                          | 0033              | Create Function GetProtocols                                                                           |  [#162][i162]                   | [@gomarcel][igomarcel] |
| iuno_marketplacecore_V0034V_20180320.sql                          | 0034              | Correct bug on checkpermissions function                                                               |  [#167][i167]                   | [@gomarcel][igomarcel] |
| iuno_marketplacecore_V0035V_20180403.sql                          | 0035              | Added Function GetTransactionByOffer                                                                   |                                 | [@mbeuttler][imbeuttler] |
| iuno_marketplacecore_V0036V_20180404.sql                          | 0036              | Added clientId column to protocols table                                                               |  [#174][i174]                   | [@mbeuttler][imbeuttler] |
| iuno_marketplacecore_V0037V_20180405.sql                          | 0037              | Updated GetProtocols function to include ClientId filter. Introduced new function GetLastProtocolForEachClient: Returning only the last protocol for each client.   |  [#176][i176]                   | [@mbeuttler][imbeuttler] |
| iuno_marketplacecore_V0038V_20180508.sql                          | 0038              | Fixed where clause in GetLastProtocolForEachClient function                                            |                                 | [@mbeuttler][imbeuttler] |
| iuno_marketplacecore_V0039V_20180518.sql                          | 0039              | Created new function to get the encrypted technologydata for paid orders                               |  [#186][i186]                   | [@mbeuttler][imbeuttler] |
| iuno_marketplacecore_V0040V_20180522.sql                          | 0040              | Adding a new table to log request information and allow brute-force protection in the backend          |  [#184][i184]                   | [@mbeuttler][imbeuttler] |
| iuno_marketplacecore_V0041V_20180702.sql                          | 0041              | Adding permission to use createprotocols function for Admin, TechnologyAdmin and MarketplaceCore       |  [#194][i194]                   | [@mbeuttler][imbeuttler] |
| iuno_marketplacecore_V0042V_20180518.sql                          | 0042              | Add localization functionality to components - Update Database Schema                                  |  [#179][i179]                 | [@gomarcel][igomarcel]  |
| iuno_marketplacecore_V0043V_20180518.sql                          | 0043              | Update components functions to provide localization functionality                                      |  [#179][i179]                 | [@gomarcel][igomarcel]  |
| iuno_marketplacecore_V0044V_20180612.sql                          | 0044              | Insert values for component translations into translations table                                       |  [#179][i179]                 | [@gomarcel][igomarcel]  |
| iuno_marketplacecore_V0045V_20180709.sql                          | 0045              | Updated components function to include technologies and attributes                                     |  [#198][i198][#199][i199]     | [@mbeuttler][imbeuttler]  |
| iuno_marketplacecore_V0046V_20180712.sql                          | 0046              | Updated GetTechnologydataByParams                                                                      |                               | [@mbeuttler][imbeuttler]  |
| iuno_marketplacecore_V0047V_20180713.sql                          | 0047              | Update reports functions to handle different technologies                                              |                               | [@gomarcel][igomarcel]  |
| iuno_marketplacecore_V0048V_20180723.sql                          | 0048              | Create Function UpdateTechnologyData and update create and get technologydata functions                |  [#206][i206] [#207][i207]    | [@mbeuttler][imbeuttler]  |
| iuno_marketplacecore_V0049V_20180810.sql                          | 0049              | Create Function GetComponentAttributesForTechnologyData                                                |                               | [@mbeuttler][imbeuttler]  |
| iuno_marketplacecore_V0050V_20180813.sql                          | 0050              | Updating gettechnologydatawithcontent - Adding new function getPurchasedTechnologyDataForUser          |                               | [@mbeuttler][imbeuttler]  |
| iuno_marketplacecore_V0051V_20180820.sql                          | 0051              | Updated update technologydata function to also set imageref                                            |                               | [@mbeuttler][imbeuttler]  |
| iuno_marketplacecore_V0052V_20180821.sql                          | 0052              | Updated GetAllComponents                                                                               |                               | [@mbeuttler][imbeuttler]  |
| iuno_marketplacecore_V0053V_20180828.sql                          | 0053              | Updated GetTechnologyByParams function and allowed public role to access it                            |                               | [@mbeuttler][imbeuttler]  |
| iuno_marketplacecore_V0054V_20180829.sql                          | 0054              | Fixed report topComponents and totalRevenue                                                            |  [#219][i219]                 | [@mbeuttler][imbeuttler]  |
| iuno_marketplacecore_V0055V_20180912.sql                          | 0055              | Updated permissions for public role, removed duplicates in payment table, added unique constraints to payment table |  [#220][i220]                 | [@mbeuttler][imbeuttler]  |
| iuno_marketplacecore_V0056V_20180912.sql                          | 0056              | Fixed bug in getTotalUserRevenue function always returning 0                                           |  [#219][i219]                 | [@mbeuttler][imbeuttler]  |

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
[i159]: https://github.com/IUNO-TDM/MarketplaceCore/issues/159
[i162]: https://github.com/IUNO-TDM/MarketplaceCore/issues/162
[i165]: https://github.com/IUNO-TDM/MarketplaceCore/issues/165
[i167]: https://github.com/IUNO-TDM/MarketplaceCore/issues/167
[i174]: https://github.com/IUNO-TDM/MarketplaceCore/issues/174
[i176]: https://github.com/IUNO-TDM/MarketplaceCore/issues/176
[i186]: https://github.com/IUNO-TDM/MarketplaceCore/issues/186
[i184]: https://github.com/IUNO-TDM/MarketplaceCore/issues/184
[i194]: https://github.com/IUNO-TDM/MarketplaceCore/issues/194
[i179]: https://github.com/IUNO-TDM/MarketplaceCore/issues/179
[i198]: https://github.com/IUNO-TDM/MarketplaceCore/issues/198
[i199]: https://github.com/IUNO-TDM/MarketplaceCore/issues/199
[i206]: https://github.com/IUNO-TDM/MarketplaceCore/issues/206
[i207]: https://github.com/IUNO-TDM/MarketplaceCore/issues/207
[i219]: https://github.com/IUNO-TDM/MarketplaceCore/issues/219
[i220]: https://github.com/IUNO-TDM/MarketplaceCore/issues/220

[igomarcel]: https://github.com/gomarcel
[imbeuttler]: https://github.com/MBeuttler