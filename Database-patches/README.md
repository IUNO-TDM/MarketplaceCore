**MarketplaceCore Database - CHANGE-LOG**

- For new patches use the next consecutive **patch number** from the list

**IMPORTANT: USE ONLY [PatchDBTool](https://github.com/IUNO-TDM/PatchDBTool/tree/master/PatchDBTool) to deploy Patches**

|**Patchname**                                                      |**Patch number**   |**Description**                                                                                        |**Issue Number**   | **Author**                  |
|-------------------------------------------------------------------|-------------------|-------------------------------------------------------------------------------------------------------|-------------------|-----------------------------|
| 01_iuno_marketplacecore_VinitialV_20170915.sql                    | Initial version   | Initial patch after deploying DB from Master Branch. Create Patches table.                            |  [#54][i54]       | [@gomarcel][igomarcel]      |
| iuno_marketplacecore_V0001V_20170915.sql                          | 0001              | Update the SetTechnologyData and CreateTechnologyData functions. Error due to ' in TechnologyDataName |  [#91][i91]       | [@gomarcel][igomarcel]      |
| iuno_marketplacecore_V0002V_20170915.sql                          | 0002              | Updated Functions getmostusedcomponents, getworkloadsince, getactivatedlicensessince                  |  [#35][i35]       | [@gomarcel][igomarcel]      |
| iuno_marketplacecore_V0003V_20170915.sql                          | 0003              | Update the SetTechnologyData and CreateTechnologyData functions. Error due to ' in TechnologyDataName |  [#36][i36],[#110][i110],[#111][i111]       | [@gomarcel][igomarcel]      |
| iuno_marketplacecore_V0004V_20170915.sql                          | 0004              | Updated Functions getmostusedcomponents, getworkloadsince, getactivatedlicensessince                  |  [#112][i112]       | [@gomarcel][igomarcel]      |

[i54]: https://github.com/IUNO-TDM/MarketplaceCore/issues/54
[i91]: https://github.com/IUNO-TDM/MarketplaceCore/issues/91
[i35]: https://github.com/IUNO-TDM/MarketplaceCore/issues/35
[i36]: https://github.com/IUNO-TDM/MarketplaceCore/issues/36
[i110]: https://github.com/IUNO-TDM/MarketplaceCore/issues/110
[i111]: https://github.com/IUNO-TDM/MarketplaceCore/issues/111
[i112]: https://github.com/IUNO-TDM/MarketplaceCore/issues/112
[igomarcel]: https://github.com/gomarcel