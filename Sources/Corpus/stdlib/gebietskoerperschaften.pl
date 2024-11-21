:- module(gebietskoerperschaften, [eu_member/1, bundesland/2, bezirk/2, gemeinde/2]).

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
gemeinde(rohrbach, aigen_schlaegl).
gemeinde(oberoesterreich, aistersalzell).
gemeinde(oberoesterreich, alberndorf_in_der_riedmark).
gemeinde(oberoesterreich, alkoven).
gemeinde(oberoesterreich, allerheiligen_im_muehlkreis).
gemeinde(oberoesterreich, allhaming).
gemeinde(oberoesterreich, altenberg_bei_linz).
gemeinde(oberoesterreich, altenfelden).
gemeinde(oberoesterreich, altheim).
gemeinde(oberoesterreich, altmuenster).
gemeinde(oberoesterreich, altschwendt).
gemeinde(oberoesterreich, ampflwang_im_hausruckwald).
gemeinde(oberoesterreich, andorf).
gemeinde(oberoesterreich, andrichsfurt).
gemeinde(oberoesterreich, ansfelden).
gemeinde(oberoesterreich, antiesenhofen).
gemeinde(oberoesterreich, arbing).
gemeinde(oberoesterreich, arnreit).
gemeinde(oberoesterreich, aschach_an_der_donau).
gemeinde(oberoesterreich, aschach_an_der_steyr).
gemeinde(oberoesterreich, aspach).
gemeinde(oberoesterreich, asten).
gemeinde(oberoesterreich, attersee_am_attersee).
gemeinde(oberoesterreich, attnang-puchheim).
gemeinde(oberoesterreich, atzbach).
gemeinde(oberoesterreich, atzesberg).
gemeinde(oberoesterreich, auberg).
gemeinde(oberoesterreich, auerbach).
gemeinde(oberoesterreich, aurach_am_hongar).
gemeinde(oberoesterreich, aurolzmuenster).
gemeinde(oberoesterreich, bachmanning).
gemeinde(oberoesterreich, bad_goisern_am_hallstaettersee).
gemeinde(oberoesterreich, bad_hall).
gemeinde(oberoesterreich, bad_ischl).
gemeinde(oberoesterreich, bad_kreuzen).
gemeinde(oberoesterreich, bad_leonfelden).
gemeinde(oberoesterreich, bad_schallerbach).
gemeinde(oberoesterreich, bad_wimsbach-neydharting).
gemeinde(oberoesterreich, bad_zell).
gemeinde(oberoesterreich, baumgartenberg).
gemeinde(oberoesterreich, berg_im_attergau).
gemeinde(oberoesterreich, braunau_am_inn).
gemeinde(oberoesterreich, brunnenthal).
gemeinde(oberoesterreich, buchkirchen).
gemeinde(oberoesterreich, burgkirchen).
gemeinde(oberoesterreich, desselbrunn).
gemeinde(oberoesterreich, diersbach).
gemeinde(oberoesterreich, dietach).
gemeinde(oberoesterreich, dimbach).
gemeinde(oberoesterreich, dorf_an_der_pram).
gemeinde(oberoesterreich, ebensee_am_traunsee).
gemeinde(oberoesterreich, eberschwang).
gemeinde(oberoesterreich, eberstalzell).
gemeinde(oberoesterreich, edlbach).
gemeinde(oberoesterreich, edt_bei_lambach).
gemeinde(oberoesterreich, eferding).
gemeinde(oberoesterreich, eggelsberg).
gemeinde(oberoesterreich, eggendorf_im_traunkreis).
gemeinde(oberoesterreich, eggerding).
gemeinde(oberoesterreich, eidenberg).
gemeinde(oberoesterreich, eitzing).
gemeinde(oberoesterreich, engelhartszell_an_der_donau).
gemeinde(oberoesterreich, engerwitzdorf).
gemeinde(oberoesterreich, enns).
gemeinde(oberoesterreich, enzenkirchen).
gemeinde(oberoesterreich, eschenau_im_hausruckkreis).
gemeinde(oberoesterreich, esternberg).
gemeinde(oberoesterreich, feldkirchen_an_der_donau).
gemeinde(oberoesterreich, feldkirchen_bei_mattighofen).
gemeinde(oberoesterreich, fischlham).
gemeinde(oberoesterreich, fornach).
gemeinde(oberoesterreich, fraham).
gemeinde(oberoesterreich, frankenburg_am_hausruck).
gemeinde(oberoesterreich, frankenmarkt).
gemeinde(oberoesterreich, franking).
gemeinde(oberoesterreich, freinberg).
gemeinde(oberoesterreich, freistadt).
gemeinde(oberoesterreich, gaflenz).
gemeinde(oberoesterreich, gallneukirchen).
gemeinde(oberoesterreich, gallspach).
gemeinde(oberoesterreich, gampern).
gemeinde(oberoesterreich, garsten).
gemeinde(oberoesterreich, gaspoltshofen).
gemeinde(oberoesterreich, geboltskirchen).
gemeinde(oberoesterreich, geiersberg).
gemeinde(oberoesterreich, geinberg).
gemeinde(oberoesterreich, geretsberg).
gemeinde(oberoesterreich, gilgenberg_am_weilhart).
gemeinde(oberoesterreich, gmunden).
gemeinde(oberoesterreich, goldwoerth).
gemeinde(oberoesterreich, gosau).
gemeinde(oberoesterreich, gramastetten).
gemeinde(oberoesterreich, grein).
gemeinde(oberoesterreich, grieskirchen).
gemeinde(oberoesterreich, grossraming).
gemeinde(oberoesterreich, gruenau_im_almtal).
gemeinde(oberoesterreich, gruenbach).
gemeinde(oberoesterreich, gruenburg).
gemeinde(oberoesterreich, gschwandt).
gemeinde(oberoesterreich, gunskirchen).
gemeinde(oberoesterreich, gurten).
gemeinde(oberoesterreich, gutau).
gemeinde(oberoesterreich, haag_am_hausruck).
gemeinde(oberoesterreich, hagenberg_im_muehlkreis).
gemeinde(oberoesterreich, haibach_im_muehlkreis).
gemeinde(oberoesterreich, haibach_ob_der_donau).
gemeinde(oberoesterreich, haigermoos).
gemeinde(oberoesterreich, hallstatt).
gemeinde(oberoesterreich, handenberg).
gemeinde(oberoesterreich, hargelsberg).
gemeinde(oberoesterreich, hartkirchen).
gemeinde(oberoesterreich, haslach_an_der_muehl).
gemeinde(oberoesterreich, heiligenberg).
gemeinde(oberoesterreich, helfenberg).
gemeinde(oberoesterreich, hellmonsoedt).
gemeinde(oberoesterreich, helpfau-uttendorf).
gemeinde(oberoesterreich, herzogsdorf).
gemeinde(oberoesterreich, hinterstoder).
gemeinde(oberoesterreich, hinzenbach).
gemeinde(oberoesterreich, hirschbach_im_muehlkreis).
gemeinde(oberoesterreich, hochburg-ach).
gemeinde(oberoesterreich, hofkirchen_an_der_trattnach).
gemeinde(oberoesterreich, hofkirchen_im_muehlkreis).
gemeinde(oberoesterreich, hofkirchen_im_traunkreis).
gemeinde(oberoesterreich, hohenzell).
gemeinde(oberoesterreich, hoehnhart).
gemeinde(oberoesterreich, holzhausen).
gemeinde(oberoesterreich, hoerbich).
gemeinde(oberoesterreich, hoersching).
gemeinde(oberoesterreich, innerschwand_am_mondsee).
gemeinde(oberoesterreich, inzersdorf_im_kremstal).
gemeinde(oberoesterreich, jeging).
gemeinde(oberoesterreich, julbach).
gemeinde(oberoesterreich, kallham).
gemeinde(oberoesterreich, kaltenberg).
gemeinde(oberoesterreich, katsdorf).
gemeinde(oberoesterreich, kefermarkt).
gemeinde(oberoesterreich, kematen_am_innbach).
gemeinde(oberoesterreich, kematen_an_der_krems).
gemeinde(oberoesterreich, kirchberg_bei_mattighofen).
gemeinde(oberoesterreich, kirchberg_ob_der_donau).
gemeinde(oberoesterreich, kirchberg-thening).
gemeinde(oberoesterreich, kirchdorf_am_inn).
gemeinde(oberoesterreich, kirchdorf_an_der_krems).
gemeinde(oberoesterreich, kirchham).
gemeinde(oberoesterreich, kirchheim_im_innkreis).
gemeinde(oberoesterreich, kirchschlag_bei_linz).
gemeinde(oberoesterreich, klaffer_am_hochficht).
gemeinde(oberoesterreich, klam).
gemeinde(oberoesterreich, klaus_an_der_pyhrnbahn).
gemeinde(oberoesterreich, kleinzell_im_muehlkreis).
gemeinde(oberoesterreich, kollerschlag).
gemeinde(oberoesterreich, koenigswiesen).
gemeinde(oberoesterreich, kopfing_im_innkreis).
gemeinde(oberoesterreich, kremsmuenster).
gemeinde(oberoesterreich, krenglbach).
gemeinde(oberoesterreich, kronstorf).
gemeinde(oberoesterreich, laakirchen).
gemeinde(oberoesterreich, lambach).
gemeinde(oberoesterreich, lambrechten).
gemeinde(oberoesterreich, langenstein).
gemeinde(oberoesterreich, lasberg).
gemeinde(oberoesterreich, laussa).
gemeinde(oberoesterreich, lembach_im_muehlkreis).
gemeinde(oberoesterreich, lengau).
gemeinde(oberoesterreich, lenzing).
gemeinde(oberoesterreich, leonding).
gemeinde(oberoesterreich, leopoldschlag).
gemeinde(oberoesterreich, lichtenau_im_muehlkreis).
gemeinde(oberoesterreich, lichtenberg).
gemeinde(oberoesterreich, liebenau).
gemeinde(oberoesterreich, linz).
gemeinde(oberoesterreich, lochen_am_see).
gemeinde(oberoesterreich, lohnsburg_am_kobernausserwald).
gemeinde(oberoesterreich, losenstein).
gemeinde(oberoesterreich, luftenberg_an_der_donau).
gemeinde(oberoesterreich, manning).
gemeinde(oberoesterreich, marchtrenk).
gemeinde(oberoesterreich, maria_neustift).
gemeinde(oberoesterreich, maria_schmolln).
gemeinde(oberoesterreich, mattighofen).
gemeinde(oberoesterreich, mauerkirchen).
gemeinde(oberoesterreich, mauthausen).
gemeinde(oberoesterreich, mayrhof).
gemeinde(oberoesterreich, meggenhofen).
gemeinde(oberoesterreich, mehrnbach).
gemeinde(oberoesterreich, mettmach).
gemeinde(oberoesterreich, michaelnbach).
gemeinde(oberoesterreich, micheldorf_in_oberoesterreich).
gemeinde(oberoesterreich, mining).
gemeinde(oberoesterreich, mitterkirchen_im_machland).
gemeinde(oberoesterreich, molln).
gemeinde(oberoesterreich, mondsee).
gemeinde(oberoesterreich, moosbach).
gemeinde(oberoesterreich, moosdorf).
gemeinde(oberoesterreich, moerschwang).
gemeinde(oberoesterreich, muehlheim_am_inn).
gemeinde(oberoesterreich, munderfing).
gemeinde(oberoesterreich, muenzbach).
gemeinde(oberoesterreich, muenzkirchen).
gemeinde(oberoesterreich, naarn_im_machlande).
gemeinde(oberoesterreich, natternbach).
gemeinde(oberoesterreich, nebelberg).
gemeinde(oberoesterreich, neufelden).
gemeinde(oberoesterreich, neuhofen_an_der_krems).
gemeinde(oberoesterreich, neuhofen_im_innkreis).
gemeinde(oberoesterreich, neukirchen_am_walde).
gemeinde(oberoesterreich, neukirchen_an_der_enknach).
gemeinde(oberoesterreich, neukirchen_an_der_voeckla).
gemeinde(oberoesterreich, neukirchen_bei_lambach).
gemeinde(oberoesterreich, neumarkt_im_hausruckkreis).
gemeinde(oberoesterreich, neumarkt_im_muehlkreis).
gemeinde(oberoesterreich, neustift_im_muehlkreis).
gemeinde(oberoesterreich, niederkappel).
gemeinde(oberoesterreich, niederneukirchen).
gemeinde(oberoesterreich, niederthalheim).
gemeinde(oberoesterreich, niederwaldkirchen).
gemeinde(oberoesterreich, nussbach).
gemeinde(oberoesterreich, nussdorf_am_attersee).
gemeinde(oberoesterreich, oberhofen_am_irrsee).
gemeinde(oberoesterreich, oberkappel).
gemeinde(oberoesterreich, obernberg_am_inn).
gemeinde(oberoesterreich, oberndorf_bei_schwanenstadt).
gemeinde(oberoesterreich, oberneukirchen).
gemeinde(oberoesterreich, oberschlierbach).
gemeinde(oberoesterreich, obertraun).
gemeinde(oberoesterreich, oberwang).
gemeinde(oberoesterreich, oepping).
gemeinde(oberoesterreich, offenhausen).
gemeinde(oberoesterreich, oftering).
gemeinde(oberoesterreich, ohlsdorf).
gemeinde(oberoesterreich, ort_im_innkreis).
gemeinde(oberoesterreich, ostermiething).
gemeinde(oberoesterreich, ottenschlag_im_muehlkreis).
gemeinde(oberoesterreich, ottensheim).
gemeinde(oberoesterreich, ottnang_am_hausruck).
gemeinde(oberoesterreich, pabneukirchen).
gemeinde(oberoesterreich, palting).
gemeinde(oberoesterreich, pasching).
gemeinde(oberoesterreich, pattigham).
gemeinde(oberoesterreich, peilstein_im_muehlviertel).
gemeinde(oberoesterreich, pennewang).
gemeinde(oberoesterreich, perg).
gemeinde(oberoesterreich, perwang_am_grabensee).
gemeinde(oberoesterreich, peterskirchen).
gemeinde(oberoesterreich, pettenbach).
gemeinde(oberoesterreich, peuerbach).
gemeinde(oberoesterreich, pfaffing).
gemeinde(oberoesterreich, pfaffstaett).
gemeinde(oberoesterreich, pfarrkirchen_bei_bad_hall).
gemeinde(oberoesterreich, pfarrkirchen_im_muehlkreis).
gemeinde(oberoesterreich, piberbach).
gemeinde(oberoesterreich, pichl_bei_wels).
gemeinde(oberoesterreich, pierbach).
gemeinde(oberoesterreich, pilsbach).
gemeinde(oberoesterreich, pinsdorf).
gemeinde(oberoesterreich, pischelsdorf_am_engelbach).
gemeinde(oberoesterreich, pitzenberg).
gemeinde(oberoesterreich, pollham).
gemeinde(oberoesterreich, polling_im_innkreis).
gemeinde(oberoesterreich, poendorf).
gemeinde(oberoesterreich, poetting).
gemeinde(oberoesterreich, pram).
gemeinde(oberoesterreich, prambachkirchen).
gemeinde(oberoesterreich, pramet).
gemeinde(oberoesterreich, pregarten).
gemeinde(oberoesterreich, puchenau).
gemeinde(oberoesterreich, puchkirchen_am_trattberg).
gemeinde(oberoesterreich, pucking).
gemeinde(oberoesterreich, puehret).
gemeinde(oberoesterreich, pupping).
gemeinde(oberoesterreich, putzleinsdorf).
gemeinde(oberoesterreich, raab).
gemeinde(oberoesterreich, rainbach_im_innkreis).
gemeinde(oberoesterreich, rainbach_im_muehlkreis).
gemeinde(oberoesterreich, rechberg).
gemeinde(oberoesterreich, redleiten).
gemeinde(oberoesterreich, redlham).
gemeinde(oberoesterreich, regau).
gemeinde(oberoesterreich, reichenau_im_muehlkreis).
gemeinde(oberoesterreich, reichenthal).
gemeinde(oberoesterreich, reichersberg).
gemeinde(oberoesterreich, reichraming).
gemeinde(oberoesterreich, ried_im_innkreis).
gemeinde(oberoesterreich, ried_im_traunkreis).
gemeinde(oberoesterreich, ried_in_der_riedmark).
gemeinde(oberoesterreich, riedau).
gemeinde(oberoesterreich, rohr_im_kremstal).
gemeinde(oberoesterreich, rohrbach-berg).
gemeinde(oberoesterreich, roitham_am_traunfall).
gemeinde(oberoesterreich, rosenau_am_hengstpass).
gemeinde(oberoesterreich, rossbach).
gemeinde(oberoesterreich, rossleithen).
gemeinde(oberoesterreich, rottenbach).
gemeinde(oberoesterreich, ruestorf).
gemeinde(oberoesterreich, rutzenham).
gemeinde(oberoesterreich, sandl).
gemeinde(oberoesterreich, sarleinsbach).
gemeinde(oberoesterreich, sattledt).
gemeinde(oberoesterreich, saxen).
gemeinde(oberoesterreich, schalchen).
gemeinde(oberoesterreich, schardenberg).
gemeinde(oberoesterreich, schaerding).
gemeinde(oberoesterreich, scharnstein).
gemeinde(oberoesterreich, scharten).
gemeinde(oberoesterreich, schenkenfelden).
gemeinde(oberoesterreich, schiedlberg).
gemeinde(oberoesterreich, schildorn).
gemeinde(oberoesterreich, schlatt).
gemeinde(oberoesterreich, schleissheim).
gemeinde(oberoesterreich, schlierbach).
gemeinde(oberoesterreich, schluesslberg).
gemeinde(oberoesterreich, schoenau_im_muehlkreis).
gemeinde(oberoesterreich, schoerfling_am_attersee).
gemeinde(oberoesterreich, schwand_im_innkreis).
gemeinde(oberoesterreich, schwanenstadt).
gemeinde(oberoesterreich, schwarzenberg_am_boehmerwald).
gemeinde(oberoesterreich, schwertberg).
gemeinde(oberoesterreich, seewalchen_am_attersee).
gemeinde(oberoesterreich, senftenbach).
gemeinde(oberoesterreich, sierning).
gemeinde(oberoesterreich, sigharting).
gemeinde(oberoesterreich, sipbachzell).
gemeinde(oberoesterreich, sonnberg_im_muehlkreis).
gemeinde(oberoesterreich, spital_am_pyhrn).
gemeinde(oberoesterreich, st_aegidi).
gemeinde(oberoesterreich, st_agatha).
gemeinde(oberoesterreich, st_florian).
gemeinde(oberoesterreich, st_florian_am_inn).
gemeinde(oberoesterreich, st_georgen_am_fillmannsbach).
gemeinde(oberoesterreich, st_georgen_am_walde).
gemeinde(oberoesterreich, st_georgen_an_der_gusen).
gemeinde(oberoesterreich, st_georgen_bei_grieskirchen).
gemeinde(oberoesterreich, st_georgen_bei_obernberg_am_inn).
gemeinde(oberoesterreich, st_georgen_im_attergau).
gemeinde(oberoesterreich, st_gotthard_im_muehlkreis).
gemeinde(oberoesterreich, st_johann_am_walde).
gemeinde(oberoesterreich, st_johann_am_wimberg).
gemeinde(oberoesterreich, st_konrad).
gemeinde(oberoesterreich, st_leonhard_bei_freistadt).
gemeinde(oberoesterreich, st_lorenz).
gemeinde(oberoesterreich, st_marien).
gemeinde(oberoesterreich, st_marienkirchen_am_hausruck).
gemeinde(oberoesterreich, st_marienkirchen_an_der_polsenz).
gemeinde(oberoesterreich, st_marienkirchen_bei_schaerding).
gemeinde(oberoesterreich, st_martin_im_innkreis).
gemeinde(oberoesterreich, st_martin_im_muehlkreis).
gemeinde(oberoesterreich, st_nikola_an_der_donau).
gemeinde(oberoesterreich, st_oswald_bei_freistadt).
gemeinde(oberoesterreich, st_oswald_bei_haslach).
gemeinde(oberoesterreich, st_pankraz).
gemeinde(oberoesterreich, st_pantaleon).
gemeinde(oberoesterreich, st_peter_am_hart).
gemeinde(oberoesterreich, st_peter_am_wimberg).
gemeinde(oberoesterreich, st_radegund).
gemeinde(oberoesterreich, st_roman).
gemeinde(oberoesterreich, st_stefan-afiesl).
gemeinde(oberoesterreich, st_thomas).
gemeinde(oberoesterreich, st_thomas_am_blasenstein).
gemeinde(oberoesterreich, st_ulrich_bei_steyr).
gemeinde(oberoesterreich, st_ulrich_im_muehlkreis).
gemeinde(oberoesterreich, st_veit_im_innkreis).
gemeinde(oberoesterreich, st_veit_im_muehlkreis).
gemeinde(oberoesterreich, st_willibald).
gemeinde(oberoesterreich, st_wolfgang_im_salzkammergut).
gemeinde(oberoesterreich, stadl-paura).
gemeinde(oberoesterreich, steegen).
gemeinde(oberoesterreich, steinbach_am_attersee).
gemeinde(oberoesterreich, steinbach_am_ziehberg).
gemeinde(oberoesterreich, steinbach_an_der_steyr).
gemeinde(oberoesterreich, steinerkirchen_an_der_traun).
gemeinde(oberoesterreich, steinhaus).
gemeinde(oberoesterreich, steyr).
gemeinde(oberoesterreich, steyregg).
gemeinde(oberoesterreich, strass_im_attergau).
gemeinde(oberoesterreich, stroheim).
gemeinde(oberoesterreich, suben).
gemeinde(oberoesterreich, taiskirchen_im_innkreis).
gemeinde(oberoesterreich, tarsdorf).
gemeinde(oberoesterreich, taufkirchen_an_der_pram).
gemeinde(oberoesterreich, taufkirchen_an_der_trattnach).
gemeinde(oberoesterreich, ternberg).
gemeinde(oberoesterreich, thalheim_bei_wels).
gemeinde(oberoesterreich, tiefgraben).
gemeinde(oberoesterreich, timelkam).
gemeinde(oberoesterreich, tollet).
gemeinde(oberoesterreich, tragwein).
gemeinde(oberoesterreich, traun).
gemeinde(oberoesterreich, traunkirchen).
gemeinde(oberoesterreich, treubach).
gemeinde(oberoesterreich, tumeltsham).
gemeinde(oberoesterreich, ueberackern).
gemeinde(oberoesterreich, ulrichsberg).
gemeinde(oberoesterreich, ungenach).
gemeinde(oberoesterreich, unterach_am_attersee).
gemeinde(oberoesterreich, unterweissenbach).
gemeinde(oberoesterreich, unterweitersdorf).
gemeinde(oberoesterreich, utzenaich).
gemeinde(oberoesterreich, vichtenstein).
gemeinde(oberoesterreich, voecklabruck).
gemeinde(oberoesterreich, voecklamarkt).
gemeinde(oberoesterreich, vorchdorf).
gemeinde(oberoesterreich, vorderstoder).
gemeinde(oberoesterreich, vorderweissenbach).
gemeinde(oberoesterreich, waizenkirchen).
gemeinde(oberoesterreich, waldburg).
gemeinde(oberoesterreich, waldhausen_im_strudengau).
gemeinde(oberoesterreich, walding).
gemeinde(oberoesterreich, waldkirchen_am_wesen).
gemeinde(oberoesterreich, waldneukirchen).
gemeinde(oberoesterreich, waldzell).
gemeinde(oberoesterreich, wallern_an_der_trattnach).
gemeinde(oberoesterreich, wartberg_an_der_krems).
gemeinde(oberoesterreich, wartberg_ob_der_aist).
gemeinde(oberoesterreich, weibern).
gemeinde(oberoesterreich, weilbach).
gemeinde(oberoesterreich, weissenkirchen_im_attergau).
gemeinde(oberoesterreich, weisskirchen_an_der_traun).
gemeinde(oberoesterreich, weitersfelden).
gemeinde(oberoesterreich, wels).
gemeinde(oberoesterreich, wendling).
gemeinde(oberoesterreich, weng_im_innkreis).
gemeinde(oberoesterreich, wernstein_am_inn).
gemeinde(oberoesterreich, weyer).
gemeinde(oberoesterreich, weyregg_am_attersee).
gemeinde(oberoesterreich, wilhering).
gemeinde(oberoesterreich, windhaag_bei_freistadt).
gemeinde(oberoesterreich, windhaag_bei_perg).
gemeinde(oberoesterreich, windischgarsten).
gemeinde(oberoesterreich, wippenham).
gemeinde(oberoesterreich, wolfern).
gemeinde(oberoesterreich, wolfsegg_am_hausruck).
gemeinde(oberoesterreich, zell_am_moos).
gemeinde(oberoesterreich, zell_am_pettenfirst).
gemeinde(oberoesterreich, zell_an_der_pram).
gemeinde(oberoesterreich, zwettl_an_der_rodl).
