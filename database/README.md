**MarketplaceCore Database - CHANGE-LOG**

- For new patches use the next consecutive **patch number** from the list

**IMPORTANT: USE ONLY [PatchDBTool](https://github.com/IUNO-TDM/PatchDBTool/tree/master/PatchDBTool) to deploy Patches**

|**Patchname**                                                      |**Patch number**   |**Description**                                                                                        |**Issue Number**   | **Author**                  |
|-------------------------------------------------------------------|-------------------|-------------------------------------------------------------------------------------------------------|-------------------|-----------------------------|
| 01_iuno_marketplacecore_VinitialV_20170914.sql                    | Initial version   | Initial patch after deploying DB from Master Branch. Create Patches table.                            |  [#54][i54]       | [@gomarcel][igomarcel]      |
| iuno_marketplacecore_V0001V_20170915.sql                          | 0001              | Update the SetTechnologyData and CreateTechnologyData functions. Error due to ' in TechnologyDataName |  [#91][i91]       | [@gomarcel][igomarcel]      |
| iuno_marketplacecore_V0002V_20170915.sql                          | 0002              | Updated Functions getmostusedcomponents, getworkloadsince, getactivatedlicensessince                  |  [#35][i35]       | [@gomarcel][igomarcel]      |
| iuno_marketplacecore_V0003V_20170920.sql                          | 0003              | Update SetTechnologyData, split Update from Create                                                    |  [#36][i36],[#110][i110],[#111][i111]       | [@gomarcel][igomarcel]      |
| iuno_marketplacecore_V0004V_20170925.sql                          | 0004              | Fix function GetTechnologyByName due to "Ambiguous Column" problem          |  [#115][i115]       | [@gomarcel][igomarcel]      |
| iuno_marketplacecore_V0005V_20170928.sql                          | 0005              | Fix function GetTechnologyDataByName due to "Ambiguous Column" problem          |  [#112][i112]       | [@gomarcel][igomarcel]      |
| iuno_marketplacecore_V0006V_20171010.sql                          | 0006              | Delete unique constraint on the technologydataname          |  [#116][i116]       | [@gomarcel][igomarcel]      |
| iuno_marketplacecore_V0007V_20171107.sql                          | 0007              | Delete old reports functions         |  [#103][i103]       | [@gomarcel][igomarcel]      |
| iuno_marketplacecore_V0008V_20171107.sql                          | 0008              | Create new functions for report          |  [#103][i103]       | [@gomarcel][igomarcel]      |
| iuno_marketplacecore_V0009V_20171113.sql                          | 0009              | Fix Bug in function GetTechnologyDataByParams           |  [#120][i120]       | [@gomarcel][igomarcel]      |
| iuno_marketplacecore_V0010V_20171113.sql                          | 0010              | At the moment is not possible to save the imgref on the database          |  [#101][i101]       | [@gomarcel][igomarcel]      |
| iuno_marketplacecore_V0011V_20171122.sql                          | 0011              | Fix Bug in function GetTechnologyDataByParams           |  [#131][i131]       | [@gomarcel][igomarcel]      |
| iuno_marketplacecore_V0012V_20171207.sql                          | 0012              | Create new function GetActivatedLicensesCountForUser           |  [#135][i135]       | [@gomarcel][igomarcel]      |


[i54]: https://github.com/IUNO-TDM/MarketplaceCore/issues/54
[i91]: https://github.com/IUNO-TDM/MarketplaceCore/issues/91
[i35]: https://github.com/IUNO-TDM/MarketplaceCore/issues/35
[i36]: https://github.com/IUNO-TDM/MarketplaceCore/issues/36
[i103]: https://github.com/IUNO-TDM/MarketplaceCore/issues/103
[i110]: https://github.com/IUNO-TDM/MarketplaceCore/issues/110
[i111]: https://github.com/IUNO-TDM/MarketplaceCore/issues/111
[i112]: https://github.com/IUNO-TDM/MarketplaceCore/issues/112
[i115]: https://github.com/IUNO-TDM/MarketplaceCore/issues/115
[i116]: https://github.com/IUNO-TDM/MarketplaceCore/issues/116
[i120]: https://github.com/IUNO-TDM/MarketplaceCore/issues/120
[i101]: https://github.com/IUNO-TDM/MarketplaceCore/issues/101
[i131]: https://github.com/IUNO-TDM/MarketplaceCore/issues/131
[i135]: https://github.com/IUNO-TDM/MarketplaceCore/issues/135


[igomarcel]: https://github.com/gomarcel