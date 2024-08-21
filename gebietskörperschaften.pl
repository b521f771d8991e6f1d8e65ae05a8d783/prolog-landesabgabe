:- module(gebietskörperschaften, [eu_member/1, bundesland/2, bezirk/2, gemeinde/2]).

eu_member(X) :-
    X = austria ;
    X = belgium ;
    X = bulgaria ;
    X = croatia ;
    X = cyprus ;
    X = czechia ;
    X = denmark ;
    X = estonia ;
    X = finland ;
    X = france ;
    X = germany ;
    X = greece ;
    X = hungary ;
    X = ireland ;
    X = italy ;
    X = latvia ;
    X = lithuania ;
    X = luxembourg ;
    X = malta ;
    X = netherlands ;
    X = poland ;
    X = portugal ;
    X = romania ;
    X = slovakia ;
    X = slovenia ;
    X = spain ;
    X = sweden.

bundesland(austria, X) :-
    X = oberoesterreich ;
    X = niederoesterreich ;
    X = wien ;
    X = burgenland ;
    X = kaernten ;
    X = salzburg ;
    X = steiermark ;
    X = tirol ;
    X = vorarlberg.

bezirk(oberoesterreich, X) :-
    X = freistadt ;
    X = braunau_am_inn ;
    X = eferding ;
    X = gmund ;
    X = grieskirchen ;
    X = kirchdorf_an_der_krems ;
    X = linz_land ;
    X = linz_stadt ;
    X = perg ;
    X = ried_im_innkreis ;
    X = rohrbach ;
    X = scharding ;
    X = steyr_land  ;
    X = steyr_stadt ;
    X = ullsdorf  ;
    X = vocklabruck ;
    X = wels_land  ;
    X = wels_stadt.

gemeinde(steyr_land, adlwang).
gemeinde(wels_land, aichkirchen).
gemeinde(rohrbach, aigen_schlägl).
gemeinde(oberösterreich, aistersalzell).
gemeinde(oberösterreich, alberndorf_in_der_riedmark).
gemeinde(oberösterreich, alkoven).
gemeinde(oberösterreich, allerheiligen_im_mühlkreis).
gemeinde(oberösterreich, allhaming).
gemeinde(oberösterreich, altenberg_bei_linz).
gemeinde(oberösterreich, altenfelden).
gemeinde(oberösterreich, altheim).
gemeinde(oberösterreich, altmünster).
gemeinde(oberösterreich, altschwendt).
gemeinde(oberösterreich, ampflwang_im_hausruckwald).
gemeinde(oberösterreich, andorf).
gemeinde(oberösterreich, andrichsfurt).
gemeinde(oberösterreich, ansfelden).
gemeinde(oberösterreich, antiesenhofen).
gemeinde(oberösterreich, arbing).
gemeinde(oberösterreich, arnreit).
gemeinde(oberösterreich, aschach_an_der_donau).
gemeinde(oberösterreich, aschach_an_der_steyr).
gemeinde(oberösterreich, aspach).
gemeinde(oberösterreich, asten).
gemeinde(oberösterreich, attersee_am_attersee).
gemeinde(oberösterreich, attnang-puchheim).
gemeinde(oberösterreich, atzbach).
gemeinde(oberösterreich, atzesberg).
gemeinde(oberösterreich, auberg).
gemeinde(oberösterreich, auerbach).
gemeinde(oberösterreich, aurach_am_hongar).
gemeinde(oberösterreich, aurolzmünster).
gemeinde(oberösterreich, bachmanning).
gemeinde(oberösterreich, bad_goisern_am_hallstättersee).
gemeinde(oberösterreich, bad_hall).
gemeinde(oberösterreich, bad_ischl).
gemeinde(oberösterreich, bad_kreuzen).
gemeinde(oberösterreich, bad_leonfelden).
gemeinde(oberösterreich, bad_schallerbach).
gemeinde(oberösterreich, bad_wimsbach-neydharting).
gemeinde(oberösterreich, bad_zell).
gemeinde(oberösterreich, baumgartenberg).
gemeinde(oberösterreich, berg_im_attergau).
gemeinde(oberösterreich, braunau_am_inn).
gemeinde(oberösterreich, brunnenthal).
gemeinde(oberösterreich, buchkirchen).
gemeinde(oberösterreich, burgkirchen).
gemeinde(oberösterreich, desselbrunn).
gemeinde(oberösterreich, diersbach).
gemeinde(oberösterreich, dietach).
gemeinde(oberösterreich, dimbach).
gemeinde(oberösterreich, dorf_an_der_pram).
gemeinde(oberösterreich, ebensee_am_traunsee).
gemeinde(oberösterreich, eberschwang).
gemeinde(oberösterreich, eberstalzell).
gemeinde(oberösterreich, edlbach).
gemeinde(oberösterreich, edt_bei_lambach).
gemeinde(oberösterreich, eferding).
gemeinde(oberösterreich, eggelsberg).
gemeinde(oberösterreich, eggendorf_im_traunkreis).
gemeinde(oberösterreich, eggerding).
gemeinde(oberösterreich, eidenberg).
gemeinde(oberösterreich, eitzing).
gemeinde(oberösterreich, engelhartszell_an_der_donau).
gemeinde(oberösterreich, engerwitzdorf).
gemeinde(oberösterreich, enns).
gemeinde(oberösterreich, enzenkirchen).
gemeinde(oberösterreich, eschenau_im_hausruckkreis).
gemeinde(oberösterreich, esternberg).
gemeinde(oberösterreich, feldkirchen_an_der_donau).
gemeinde(oberösterreich, feldkirchen_bei_mattighofen).
gemeinde(oberösterreich, fischlham).
gemeinde(oberösterreich, fornach).
gemeinde(oberösterreich, fraham).
gemeinde(oberösterreich, frankenburg_am_hausruck).
gemeinde(oberösterreich, frankenmarkt).
gemeinde(oberösterreich, franking).
gemeinde(oberösterreich, freinberg).
gemeinde(oberösterreich, freistadt).
gemeinde(oberösterreich, gaflenz).
gemeinde(oberösterreich, gallneukirchen).
gemeinde(oberösterreich, gallspach).
gemeinde(oberösterreich, gampern).
gemeinde(oberösterreich, garsten).
gemeinde(oberösterreich, gaspoltshofen).
gemeinde(oberösterreich, geboltskirchen).
gemeinde(oberösterreich, geiersberg).
gemeinde(oberösterreich, geinberg).
gemeinde(oberösterreich, geretsberg).
gemeinde(oberösterreich, gilgenberg_am_weilhart).
gemeinde(oberösterreich, gmunden).
gemeinde(oberösterreich, goldwörth).
gemeinde(oberösterreich, gosau).
gemeinde(oberösterreich, gramastetten).
gemeinde(oberösterreich, grein).
gemeinde(oberösterreich, grieskirchen).
gemeinde(oberösterreich, großraming).
gemeinde(oberösterreich, grünau_im_almtal).
gemeinde(oberösterreich, grünbach).
gemeinde(oberösterreich, grünburg).
gemeinde(oberösterreich, gschwandt).
gemeinde(oberösterreich, gunskirchen).
gemeinde(oberösterreich, gurten).
gemeinde(oberösterreich, gutau).
gemeinde(oberösterreich, haag_am_hausruck).
gemeinde(oberösterreich, hagenberg_im_mühlkreis).
gemeinde(oberösterreich, haibach_im_mühlkreis).
gemeinde(oberösterreich, haibach_ob_der_donau).
gemeinde(oberösterreich, haigermoos).
gemeinde(oberösterreich, hallstatt).
gemeinde(oberösterreich, handenberg).
gemeinde(oberösterreich, hargelsberg).
gemeinde(oberösterreich, hartkirchen).
gemeinde(oberösterreich, haslach_an_der_mühl).
gemeinde(oberösterreich, heiligenberg).
gemeinde(oberösterreich, helfenberg).
gemeinde(oberösterreich, hellmonsödt).
gemeinde(oberösterreich, helpfau-uttendorf).
gemeinde(oberösterreich, herzogsdorf).
gemeinde(oberösterreich, hinterstoder).
gemeinde(oberösterreich, hinzenbach).
gemeinde(oberösterreich, hirschbach_im_mühlkreis).
gemeinde(oberösterreich, hochburg-ach).
gemeinde(oberösterreich, hofkirchen_an_der_trattnach).
gemeinde(oberösterreich, hofkirchen_im_mühlkreis).
gemeinde(oberösterreich, hofkirchen_im_traunkreis).
gemeinde(oberösterreich, hohenzell).
gemeinde(oberösterreich, höhnhart).
gemeinde(oberösterreich, holzhausen).
gemeinde(oberösterreich, hörbich).
gemeinde(oberösterreich, hörsching).
gemeinde(oberösterreich, innerschwand_am_mondsee).
gemeinde(oberösterreich, inzersdorf_im_kremstal).
gemeinde(oberösterreich, jeging).
gemeinde(oberösterreich, julbach).
gemeinde(oberösterreich, kallham).
gemeinde(oberösterreich, kaltenberg).
gemeinde(oberösterreich, katsdorf).
gemeinde(oberösterreich, kefermarkt).
gemeinde(oberösterreich, kematen_am_innbach).
gemeinde(oberösterreich, kematen_an_der_krems).
gemeinde(oberösterreich, kirchberg_bei_mattighofen).
gemeinde(oberösterreich, kirchberg_ob_der_donau).
gemeinde(oberösterreich, kirchberg-thening).
gemeinde(oberösterreich, kirchdorf_am_inn).
gemeinde(oberösterreich, kirchdorf_an_der_krems).
gemeinde(oberösterreich, kirchham).
gemeinde(oberösterreich, kirchheim_im_innkreis).
gemeinde(oberösterreich, kirchschlag_bei_linz).
gemeinde(oberösterreich, klaffer_am_hochficht).
gemeinde(oberösterreich, klam).
gemeinde(oberösterreich, klaus_an_der_pyhrnbahn).
gemeinde(oberösterreich, kleinzell_im_mühlkreis).
gemeinde(oberösterreich, kollerschlag).
gemeinde(oberösterreich, königswiesen).
gemeinde(oberösterreich, kopfing_im_innkreis).
gemeinde(oberösterreich, kremsmünster).
gemeinde(oberösterreich, krenglbach).
gemeinde(oberösterreich, kronstorf).
gemeinde(oberösterreich, laakirchen).
gemeinde(oberösterreich, lambach).
gemeinde(oberösterreich, lambrechten).
gemeinde(oberösterreich, langenstein).
gemeinde(oberösterreich, lasberg).
gemeinde(oberösterreich, laussa).
gemeinde(oberösterreich, lembach_im_mühlkreis).
gemeinde(oberösterreich, lengau).
gemeinde(oberösterreich, lenzing).
gemeinde(oberösterreich, leonding).
gemeinde(oberösterreich, leopoldschlag).
gemeinde(oberösterreich, lichtenau_im_mühlkreis).
gemeinde(oberösterreich, lichtenberg).
gemeinde(oberösterreich, liebenau).
gemeinde(oberösterreich, linz).
gemeinde(oberösterreich, lochen_am_see).
gemeinde(oberösterreich, lohnsburg_am_kobernaußerwald).
gemeinde(oberösterreich, losenstein).
gemeinde(oberösterreich, luftenberg_an_der_donau).
gemeinde(oberösterreich, manning).
gemeinde(oberösterreich, marchtrenk).
gemeinde(oberösterreich, maria_neustift).
gemeinde(oberösterreich, maria_schmolln).
gemeinde(oberösterreich, mattighofen).
gemeinde(oberösterreich, mauerkirchen).
gemeinde(oberösterreich, mauthausen).
gemeinde(oberösterreich, mayrhof).
gemeinde(oberösterreich, meggenhofen).
gemeinde(oberösterreich, mehrnbach).
gemeinde(oberösterreich, mettmach).
gemeinde(oberösterreich, michaelnbach).
gemeinde(oberösterreich, micheldorf_in_oberösterreich).
gemeinde(oberösterreich, mining).
gemeinde(oberösterreich, mitterkirchen_im_machland).
gemeinde(oberösterreich, molln).
gemeinde(oberösterreich, mondsee).
gemeinde(oberösterreich, moosbach).
gemeinde(oberösterreich, moosdorf).
gemeinde(oberösterreich, mörschwang).
gemeinde(oberösterreich, mühlheim_am_inn).
gemeinde(oberösterreich, munderfing).
gemeinde(oberösterreich, münzbach).
gemeinde(oberösterreich, münzkirchen).
gemeinde(oberösterreich, naarn_im_machlande).
gemeinde(oberösterreich, natternbach).
gemeinde(oberösterreich, nebelberg).
gemeinde(oberösterreich, neufelden).
gemeinde(oberösterreich, neuhofen_an_der_krems).
gemeinde(oberösterreich, neuhofen_im_innkreis).
gemeinde(oberösterreich, neukirchen_am_walde).
gemeinde(oberösterreich, neukirchen_an_der_enknach).
gemeinde(oberösterreich, neukirchen_an_der_vöckla).
gemeinde(oberösterreich, neukirchen_bei_lambach).
gemeinde(oberösterreich, neumarkt_im_hausruckkreis).
gemeinde(oberösterreich, neumarkt_im_mühlkreis).
gemeinde(oberösterreich, neustift_im_mühlkreis).
gemeinde(oberösterreich, niederkappel).
gemeinde(oberösterreich, niederneukirchen).
gemeinde(oberösterreich, niederthalheim).
gemeinde(oberösterreich, niederwaldkirchen).
gemeinde(oberösterreich, nußbach).
gemeinde(oberösterreich, nußdorf_am_attersee).
gemeinde(oberösterreich, oberhofen_am_irrsee).
gemeinde(oberösterreich, oberkappel).
gemeinde(oberösterreich, obernberg_am_inn).
gemeinde(oberösterreich, oberndorf_bei_schwanenstadt).
gemeinde(oberösterreich, oberneukirchen).
gemeinde(oberösterreich, oberschlierbach).
gemeinde(oberösterreich, obertraun).
gemeinde(oberösterreich, oberwang).
gemeinde(oberösterreich, oepping).
gemeinde(oberösterreich, offenhausen).
gemeinde(oberösterreich, oftering).
gemeinde(oberösterreich, ohlsdorf).
gemeinde(oberösterreich, ort_im_innkreis).
gemeinde(oberösterreich, ostermiething).
gemeinde(oberösterreich, ottenschlag_im_mühlkreis).
gemeinde(oberösterreich, ottensheim).
gemeinde(oberösterreich, ottnang_am_hausruck).
gemeinde(oberösterreich, pabneukirchen).
gemeinde(oberösterreich, palting).
gemeinde(oberösterreich, pasching).
gemeinde(oberösterreich, pattigham).
gemeinde(oberösterreich, peilstein_im_mühlviertel).
gemeinde(oberösterreich, pennewang).
gemeinde(oberösterreich, perg).
gemeinde(oberösterreich, perwang_am_grabensee).
gemeinde(oberösterreich, peterskirchen).
gemeinde(oberösterreich, pettenbach).
gemeinde(oberösterreich, peuerbach).
gemeinde(oberösterreich, pfaffing).
gemeinde(oberösterreich, pfaffstätt).
gemeinde(oberösterreich, pfarrkirchen_bei_bad_hall).
gemeinde(oberösterreich, pfarrkirchen_im_mühlkreis).
gemeinde(oberösterreich, piberbach).
gemeinde(oberösterreich, pichl_bei_wels).
gemeinde(oberösterreich, pierbach).
gemeinde(oberösterreich, pilsbach).
gemeinde(oberösterreich, pinsdorf).
gemeinde(oberösterreich, pischelsdorf_am_engelbach).
gemeinde(oberösterreich, pitzenberg).
gemeinde(oberösterreich, pollham).
gemeinde(oberösterreich, polling_im_innkreis).
gemeinde(oberösterreich, pöndorf).
gemeinde(oberösterreich, pötting).
gemeinde(oberösterreich, pram).
gemeinde(oberösterreich, prambachkirchen).
gemeinde(oberösterreich, pramet).
gemeinde(oberösterreich, pregarten).
gemeinde(oberösterreich, puchenau).
gemeinde(oberösterreich, puchkirchen_am_trattberg).
gemeinde(oberösterreich, pucking).
gemeinde(oberösterreich, pühret).
gemeinde(oberösterreich, pupping).
gemeinde(oberösterreich, putzleinsdorf).
gemeinde(oberösterreich, raab).
gemeinde(oberösterreich, rainbach_im_innkreis).
gemeinde(oberösterreich, rainbach_im_mühlkreis).
gemeinde(oberösterreich, rechberg).
gemeinde(oberösterreich, redleiten).
gemeinde(oberösterreich, redlham).
gemeinde(oberösterreich, regau).
gemeinde(oberösterreich, reichenau_im_mühlkreis).
gemeinde(oberösterreich, reichenthal).
gemeinde(oberösterreich, reichersberg).
gemeinde(oberösterreich, reichraming).
gemeinde(oberösterreich, ried_im_innkreis).
gemeinde(oberösterreich, ried_im_traunkreis).
gemeinde(oberösterreich, ried_in_der_riedmark).
gemeinde(oberösterreich, riedau).
gemeinde(oberösterreich, rohr_im_kremstal).
gemeinde(oberösterreich, rohrbach-berg).
gemeinde(oberösterreich, roitham_am_traunfall).
gemeinde(oberösterreich, rosenau_am_hengstpaß).
gemeinde(oberösterreich, roßbach).
gemeinde(oberösterreich, roßleithen).
gemeinde(oberösterreich, rottenbach).
gemeinde(oberösterreich, rüstorf).
gemeinde(oberösterreich, rutzenham).
gemeinde(oberösterreich, sandl).
gemeinde(oberösterreich, sarleinsbach).
gemeinde(oberösterreich, sattledt).
gemeinde(oberösterreich, saxen).
gemeinde(oberösterreich, schalchen).
gemeinde(oberösterreich, schardenberg).
gemeinde(oberösterreich, schärding).
gemeinde(oberösterreich, scharnstein).
gemeinde(oberösterreich, scharten).
gemeinde(oberösterreich, schenkenfelden).
gemeinde(oberösterreich, schiedlberg).
gemeinde(oberösterreich, schildorn).
gemeinde(oberösterreich, schlatt).
gemeinde(oberösterreich, schleißheim).
gemeinde(oberösterreich, schlierbach).
gemeinde(oberösterreich, schlüßlberg).
gemeinde(oberösterreich, schönau_im_mühlkreis).
gemeinde(oberösterreich, schörfling_am_attersee).
gemeinde(oberösterreich, schwand_im_innkreis).
gemeinde(oberösterreich, schwanenstadt).
gemeinde(oberösterreich, schwarzenberg_am_böhmerwald).
gemeinde(oberösterreich, schwertberg).
gemeinde(oberösterreich, seewalchen_am_attersee).
gemeinde(oberösterreich, senftenbach).
gemeinde(oberösterreich, sierning).
gemeinde(oberösterreich, sigharting).
gemeinde(oberösterreich, sipbachzell).
gemeinde(oberösterreich, sonnberg_im_mühlkreis).
gemeinde(oberösterreich, spital_am_pyhrn).
gemeinde(oberösterreich, st_aegidi).
gemeinde(oberösterreich, st_agatha).
gemeinde(oberösterreich, st_florian).
gemeinde(oberösterreich, st_florian_am_inn).
gemeinde(oberösterreich, st_georgen_am_fillmannsbach).
gemeinde(oberösterreich, st_georgen_am_walde).
gemeinde(oberösterreich, st_georgen_an_der_gusen).
gemeinde(oberösterreich, st_georgen_bei_grieskirchen).
gemeinde(oberösterreich, st_georgen_bei_obernberg_am_inn).
gemeinde(oberösterreich, st_georgen_im_attergau).
gemeinde(oberösterreich, st_gotthard_im_mühlkreis).
gemeinde(oberösterreich, st_johann_am_walde).
gemeinde(oberösterreich, st_johann_am_wimberg).
gemeinde(oberösterreich, st_konrad).
gemeinde(oberösterreich, st_leonhard_bei_freistadt).
gemeinde(oberösterreich, st_lorenz).
gemeinde(oberösterreich, st_marien).
gemeinde(oberösterreich, st_marienkirchen_am_hausruck).
gemeinde(oberösterreich, st_marienkirchen_an_der_polsenz).
gemeinde(oberösterreich, st_marienkirchen_bei_schärding).
gemeinde(oberösterreich, st_martin_im_innkreis).
gemeinde(oberösterreich, st_martin_im_mühlkreis).
gemeinde(oberösterreich, st_nikola_an_der_donau).
gemeinde(oberösterreich, st_oswald_bei_freistadt).
gemeinde(oberösterreich, st_oswald_bei_haslach).
gemeinde(oberösterreich, st_pankraz).
gemeinde(oberösterreich, st_pantaleon).
gemeinde(oberösterreich, st_peter_am_hart).
gemeinde(oberösterreich, st_peter_am_wimberg).
gemeinde(oberösterreich, st_radegund).
gemeinde(oberösterreich, st_roman).
gemeinde(oberösterreich, st_stefan-afiesl).
gemeinde(oberösterreich, st_thomas).
gemeinde(oberösterreich, st_thomas_am_blasenstein).
gemeinde(oberösterreich, st_ulrich_bei_steyr).
gemeinde(oberösterreich, st_ulrich_im_mühlkreis).
gemeinde(oberösterreich, st_veit_im_innkreis).
gemeinde(oberösterreich, st_veit_im_mühlkreis).
gemeinde(oberösterreich, st_willibald).
gemeinde(oberösterreich, st_wolfgang_im_salzkammergut).
gemeinde(oberösterreich, stadl-paura).
gemeinde(oberösterreich, steegen).
gemeinde(oberösterreich, steinbach_am_attersee).
gemeinde(oberösterreich, steinbach_am_ziehberg).
gemeinde(oberösterreich, steinbach_an_der_steyr).
gemeinde(oberösterreich, steinerkirchen_an_der_traun).
gemeinde(oberösterreich, steinhaus).
gemeinde(oberösterreich, steyr).
gemeinde(oberösterreich, steyregg).
gemeinde(oberösterreich, straß_im_attergau).
gemeinde(oberösterreich, stroheim).
gemeinde(oberösterreich, suben).
gemeinde(oberösterreich, taiskirchen_im_innkreis).
gemeinde(oberösterreich, tarsdorf).
gemeinde(oberösterreich, taufkirchen_an_der_pram).
gemeinde(oberösterreich, taufkirchen_an_der_trattnach).
gemeinde(oberösterreich, ternberg).
gemeinde(oberösterreich, thalheim_bei_wels).
gemeinde(oberösterreich, tiefgraben).
gemeinde(oberösterreich, timelkam).
gemeinde(oberösterreich, tollet).
gemeinde(oberösterreich, tragwein).
gemeinde(oberösterreich, traun).
gemeinde(oberösterreich, traunkirchen).
gemeinde(oberösterreich, treubach).
gemeinde(oberösterreich, tumeltsham).
gemeinde(oberösterreich, überackern).
gemeinde(oberösterreich, ulrichsberg).
gemeinde(oberösterreich, ungenach).
gemeinde(oberösterreich, unterach_am_attersee).
gemeinde(oberösterreich, unterweißenbach).
gemeinde(oberösterreich, unterweitersdorf).
gemeinde(oberösterreich, utzenaich).
gemeinde(oberösterreich, vichtenstein).
gemeinde(oberösterreich, vöcklabruck).
gemeinde(oberösterreich, vöcklamarkt).
gemeinde(oberösterreich, vorchdorf).
gemeinde(oberösterreich, vorderstoder).
gemeinde(oberösterreich, vorderweißenbach).
gemeinde(oberösterreich, waizenkirchen).
gemeinde(oberösterreich, waldburg).
gemeinde(oberösterreich, waldhausen_im_strudengau).
gemeinde(oberösterreich, walding).
gemeinde(oberösterreich, waldkirchen_am_wesen).
gemeinde(oberösterreich, waldneukirchen).
gemeinde(oberösterreich, waldzell).
gemeinde(oberösterreich, wallern_an_der_trattnach).
gemeinde(oberösterreich, wartberg_an_der_krems).
gemeinde(oberösterreich, wartberg_ob_der_aist).
gemeinde(oberösterreich, weibern).
gemeinde(oberösterreich, weilbach).
gemeinde(oberösterreich, weißenkirchen_im_attergau).
gemeinde(oberösterreich, weißkirchen_an_der_traun).
gemeinde(oberösterreich, weitersfelden).
gemeinde(oberösterreich, wels).
gemeinde(oberösterreich, wendling).
gemeinde(oberösterreich, weng_im_innkreis).
gemeinde(oberösterreich, wernstein_am_inn).
gemeinde(oberösterreich, weyer).
gemeinde(oberösterreich, weyregg_am_attersee).
gemeinde(oberösterreich, wilhering).
gemeinde(oberösterreich, windhaag_bei_freistadt).
gemeinde(oberösterreich, windhaag_bei_perg).
gemeinde(oberösterreich, windischgarsten).
gemeinde(oberösterreich, wippenham).
gemeinde(oberösterreich, wolfern).
gemeinde(oberösterreich, wolfsegg_am_hausruck).
gemeinde(oberösterreich, zell_am_moos).
gemeinde(oberösterreich, zell_am_pettenfirst).
gemeinde(oberösterreich, zell_an_der_pram).
gemeinde(oberösterreich, zwettl_an_der_rodl).
