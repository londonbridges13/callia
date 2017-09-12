require "csv"
class SettingsController < ApplicationController
  before_action :set_setting, only: [:show, :edit, :update, :destroy]

  # GET /settings
  # GET /settings.json
  def index
    @settings = Setting.all
  end


  def obtain_prospect
    url = "https://npidb.org/organizations/agencies/in-home-supportive-care_253z00000x/1497012322.aspx"
    uri = params[:uri]
    @html = search_homecare_prospect(uri)#"kl"

    @urls = ["https://npidb.org/organizations/agencies/home-health_251e00000x/1619270691.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1740597954.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1578956298.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1710016258.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1013292200.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1336414325.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1659569457.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1063552198.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1962596957.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1720347628.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1477831162.aspx",
      "https://npidb.org/organizations/agencies/home-health_251e00000x/1326323908.aspx",
       "https://npidb.org/organizations/agencies/in-home-supportive-care_253z00000x/1265842421.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1790803807.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1790862407.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1235436940.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1699879601.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1073874087.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1154571479.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1609312305.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1891864310.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1225149743.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1912130881.aspx",
        "https://npidb.org/organizations/agencies/home-health_251e00000x/1992193833.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1215233911.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1023557071.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1932432226.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1326580424.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1114284643.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1073913539.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1538429147.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1346658267.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1699195206.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1225135122.aspx",
        "https://npidb.org/organizations/agencies/home-health_251e00000x/1649729484.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1689679672.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1245388420.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1205038999.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1144552605.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1669712329.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1881839306.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1659604569.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1598171811.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1558658096.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1851600605.aspx",
        "https://npidb.org/organizations/agencies/home-health_251e00000x/1477899342.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1154603942.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1821395872.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1972807634.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1093996472.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1457766024.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1679782494.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1871864058.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1548522576.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1932447315.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1477829828.aspx",
        "https://npidb.org/organizations/agencies/home-health_251e00000x/1992997365.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1770895948.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1306091160.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1720415755.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1871920728.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1730367715.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1902885312.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1902178130.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1225130669.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1124041892.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1619068418.aspx",
        "https://npidb.org/organizations/agencies/home-health_251e00000x/1992095632.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1639315278.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1750336434.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1861786287.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1922393297.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1427398049.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1285061523.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1588107965.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1114350196.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1396974929.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1083984769.aspx",
        "https://npidb.org/organizations/agencies/home-health_251e00000x/1265869770.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1184863995.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1891022042.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1043631781.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1457672065.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1477708899.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1144651795.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1902197999.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1720332521.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1932418530.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1144551201.aspx",
         "https://npidb.org/organizations/agencies/home-health_251e00000x/1497823785.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1912213463.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1407095441.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1487977823.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1205376084.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1013292200.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1770844870.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1659463115.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1710395272.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1326273012.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1942637673.aspx",
          "https://npidb.org/organizations/agencies/home-health_251e00000x/1710907704.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1881770899.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1851620223.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1043417512.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1134382682.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1275811697.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1730483389.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1265972343.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1447510086.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1881951481.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1992863617.aspx",
          "https://npidb.org/organizations/agencies/home-health_251e00000x/1245568708.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1669417879.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1255620480.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1396157228.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1922338441.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1093070468.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1285932376.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1184947285.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1194243816.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1457537813.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1861733263.aspx",
          "https://npidb.org/organizations/agencies/home-health_251e00000x/1487978615.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1932382033.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1497814883.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1578841862.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1184073116.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1649618281.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1144779000.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1861749772.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1043354699.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1760668909.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1912249509.aspx",
          "https://npidb.org/organizations/agencies/home-health_251e00000x/1497940746.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1336225960.aspx", "https://npidb.org/organizations/agencies/in-home-supportive-care_253z00000x/1295285922.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1629371083.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1295063063.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1578947214.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1043756471.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1154652774.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1124467501.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1295097418.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1184881666.aspx",
           "https://npidb.org/organizations/agencies/home-health_251e00000x/1134405657.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1730317207.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1841638327.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1942512645.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1427394063.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1932428570.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1043533524.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1982768289.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1811379050.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1417402405.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1174920573.aspx",
            "https://npidb.org/organizations/agencies/home-health_251e00000x/1033443502.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1902160641.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1265853212.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1538463054.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1992060719.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1518254820.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1144479486.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1720189673.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1124176375.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1114222841.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1689904385.aspx",
            "https://npidb.org/organizations/agencies/home-health_251e00000x/1568890853.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1780821967.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1639592405.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1457630907.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1184067209.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1316374168.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1750667085.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1851661904.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1861795262.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1720517907.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1639446792.aspx",
            "https://npidb.org/organizations/agencies/home-health_251e00000x/1932446085.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1649526138.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1568817427.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1417159336.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1275683476.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1073871695.aspx", "https://npidb.org/organizations/agencies/in-home-supportive-care_253z00000x/1447703848.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1093013807.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1316008873.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1558798645.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1184657520.aspx",
             "https://npidb.org/organizations/agencies/home-health_251e00000x/1710006630.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1588984215.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1124401914.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1255402962.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1447317433.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1255682696.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1790056240.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1720406259.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1902192842.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1295031326.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1730316662.aspx",
             "https://npidb.org/organizations/agencies/home-health_251e00000x/1952548034.aspx", "https://npidb.org/organizations/respite_care_facility/respite-care_385h00000x/1053676486.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1174757801.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1619240827.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1295998003.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1053683169.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1083045611.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1780921858.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1700101995.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1992144133.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1356671432.aspx",
             "https://npidb.org/organizations/agencies/home-health_251e00000x/1073773719.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1043568504.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1265713952.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1982025854.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1649544586.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1811331655.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1316004724.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1902982366.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1033532247.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1477969202.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1861880643.aspx",
              "https://npidb.org/organizations/agencies/home-health_251e00000x/1609151448.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1154625333.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1003341884.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1952767824.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1003138322.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1912158304.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1235679580.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1770961054.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1104967033.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1750719753.aspx",
             "https://npidb.org/organizations/agencies/home-health_251e00000x/1891068425.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1407159064.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1407082290.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1003361452.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1447313895.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1649566274.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1497158646.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1285962506.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1619241445.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1114246402.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1174857999.aspx",
              "https://npidb.org/organizations/agencies/home-health_251e00000x/1689875015.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1023382835.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1720418676.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1790092799.aspx",
             "https://npidb.org/organizations/agencies/home-health_251e00000x/1164740866.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1679809750.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1245695915.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1760618995.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1255655775.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1295102820.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1255639373.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1043547177.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1417298571.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1043581572.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1740339530.aspx",
             "https://npidb.org/organizations/agencies/home-health_251e00000x/1700147154.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1992019574.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1235156316.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1619211752.aspx",
              "https://npidb.org/organizations/agencies/home-health_251e00000x/1134206980.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1821527433.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1912269648.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1023275815.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1144537739.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1518206937.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1316342397.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1538596754.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1538363957.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1164978854.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1871930164.aspx",
               "https://npidb.org/organizations/agencies/home-health_251e00000x/1750678983.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1881913374.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1710268024.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1770775843.aspx",
              "https://npidb.org/organizations/agencies/home-health_251e00000x/1083863369.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1235279886.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1174669956.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1861618175.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1134377740.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1952593766.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1154681849.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1235684226.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1881960565.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1841525573.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1023308855.aspx",
               "https://npidb.org/organizations/managed_care/health-maintenance-organization_302r00000x/1548387582.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1730505686.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1184885113.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1033432422.aspx",
              "https://npidb.org/organizations/agencies/home-health_251e00000x/1255771069.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1194140871.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1942572821.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1548568652.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1528398476.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1417328642.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1679842249.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1881913192.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1336428085.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1558308973.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1740530120.aspx",
              "https://npidb.org/organizations/agencies/home-health_251e00000x/1578512018.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1730638263.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1336484773.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1174810055.aspx",
             "https://npidb.org/organizations/agencies/home-health_251e00000x/1659708634.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1710316542.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1578865374.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1245569060.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1396038535.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1902157134.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1093080772.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1497827109.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1902178502.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1932343480.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1710229265.aspx",
             "https://npidb.org/organizations/agencies/home-health_251e00000x/1598198731.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1811260367.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1174820062.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1710377932.aspx",
             "https://npidb.org/organizations/agencies/home-health_251e00000x/1073605135.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1326365966.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1194167148.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1023452695.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1376882266.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1093095416.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1164747051.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1437571015.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1851520811.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1508103631.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1215031380.aspx",
              "https://npidb.org/organizations/agencies/home-health_251e00000x/1619392313.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1164716825.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1457899908.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1104884923.aspx",
              "https://npidb.org/organizations/agencies/home-health_251e00000x/1144610551.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1912228008.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1205181047.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1871722678.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1285014563.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1780095331.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1730468448.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1447392279.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1164777678.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1881066017.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1861741415.aspx",
              "https://npidb.org/organizations/agencies/home-health_251e00000x/1194134767.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1326312828.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1952758336.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1851692453.aspx",
             "https://npidb.org/organizations/agencies/home-health_251e00000x/1619276441.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1285929372.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1902163652.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1205117801.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1750397550.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1497034029.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1790155596.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1053629717.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1881097327.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1073905022.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1891023610.aspx",
              "https://npidb.org/organizations/agencies/in-home-supportive-care_253z00000x/1750640223.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1083905475.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1164663548.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1861726333.aspx",
              "https://npidb.org/organizations/agencies/home-health_251e00000x/1639440571.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1699219782.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1437695897.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1083859417.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1871940643.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1245469105.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1063552198.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1396974002.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1427284207.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1568633329.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1013064179.aspx",
              "https://npidb.org/organizations/agencies/home-health_251e00000x/1861574113.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1790803807.aspx", "https://npidb.org/organizations/agencies/home-health_251e00000x/1538477864.aspx"]

    # to_csv @urls

    @data = []
    @urls.each do |s|
      info = search_homecare_prospect s
      @data.push info
    end

  end

  def export
    @urls = []# Enter urls here
    urls = @urls#params[:urls]
    data = []
    urls.each do |url|
      info = search_homecare_prospect(url)
      if info
        data << info#attributes.map{ |attr| url.send(attr) }
      end
    end

    respond_to do |format|
      format.html { redirect_to root_url }
      format.csv { send_data to_csv(data)}#data.to_csv }
    end
  end

  def search_homecare_prospect(url)# Create A Page/ Route In Routes.rb
    site = "#{Nokogiri::HTML(open(url))}"
    p url
    # return site
    #search for Contact Information, then scrap everything until it
    # then get the company name (search lead text-success, then scrap until >)

    company_name_index = site.index("lead text-success")
    text = site[company_name_index...site.length]
    opener_index = text.index(">")
    closer_index = text.index("<")
    company_name = text[opener_index + 1...closer_index]

    # return company_name

    # search for padding-left:20px;, then scrap until br> (clears the address)
    # scrap til >, (here is your city/town)
    # scrap until next <span>, (this is your state)
    city_name_index = site.index("padding-left:20px;")
    newtext = site[city_name_index...site.length]
    br_index = newtext.index("br>")
    newtext2 = newtext[br_index...site.length]
    closer_index = newtext2.index("<")
    span_index1 = newtext.index("<span>")
    closing_span_index1 = newtext2.index("</span>")
    # return newtext2
    city = newtext2[closer_index + 6...closing_span_index1]

    # return city

    span_index = newtext2.index(", <span>")

    newtext3 = newtext2[span_index...607]
    closing_span_index2 = newtext3.index("</span>")

    state = newtext3[8...closing_span_index2]

    # return state

    location = "#{city}, #{state}"
    opener_index = newtext.index(">")

    span_index = newtext.index("<span>")
    newtext3 = newtext[opener_index...site.length]
    closer_index = newtext.index("<")
    city_name = newtext[opener_index + 1...closer_index]

    # scrap until telephone, then scrap until >, here is your phone number
    phone_index = newtext3.index("telephone")
    newtext4 = newtext3[phone_index...phone_index + 300]
    closer_index2 = newtext4.index("</span>")
    telephone = newtext4[11...closer_index2]

    # return telephone

    #scrap until Authorized official, then scrap until <span>, here is your contact's name
    authorized_name_index = text.index("Authorized official")
    newtext5 = text[authorized_name_index...authorized_name_index + 1000]
    closer_index3 = newtext5.index("</span>")
    open_index3 = newtext5.index("<span>")
    name = newtext5[open_index3 + 6...closer_index3]
    # return name

    array = {
      "name" => name.delete!("\t").delete!("\n").delete!("\r"),
      "location" => location,
      "telephone" => telephone,
      "company" => company_name.delete!("\t").delete!("\n").delete!("\r")
    }

    return array
  end


  def to_csv(data)
    attributes = ["name", "location", "telephone", "company"]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      data.each do |d|
        csv << d#[d.name,d.location, d.telephone, d.company]
      end

    end
  end


  # GET /settings/1
  # GET /settings/1.json
  def show
  end

  # GET /settings/new
  def new
    @setting = Setting.new
  end

  # GET /settings/1/edit
  def edit
  end

  # POST /settings
  # POST /settings.json
  def create
    @setting = Setting.new(setting_params)

    respond_to do |format|
      if @setting.save
        format.html { redirect_to @setting, notice: 'Setting was successfully created.' }
        format.json { render :show, status: :created, location: @setting }
      else
        format.html { render :new }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/1
  # PATCH/PUT /settings/1.json
  def update
    respond_to do |format|
      if @setting.update(setting_params)
        format.html { redirect_to @setting, notice: 'Setting was successfully updated.' }
        format.json { render :show, status: :ok, location: @setting }
      else
        format.html { render :edit }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/1
  # DELETE /settings/1.json
  def destroy
    @setting.destroy
    respond_to do |format|
      format.html { redirect_to settings_url, notice: 'Setting was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_setting
      @setting = Setting.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def setting_params
      params.require(:setting).permit(:first_name, :allow_reminder_for_birthdays)
    end
end
