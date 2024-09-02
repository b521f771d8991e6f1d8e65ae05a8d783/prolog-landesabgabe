import Foundation
import XCTest

@testable import ActKit

class ActKitTests: XCTestCase {
    static let allTests = [
        ("testLegalElements", testLegalElements)
    ]

    func testLegalElements() {
        let landschaftsabgabegesetz = ActKit.makeActWith(
            name:
                "Landesgesetz über eine Landesabgabe für das obertägige Gewinnen mineralischer Rohstoffe (Oö. Landschaftsabgabegesetz)",
            andDateEnacted: Date()
        ) {
            makeParagraphWith(number: 1, andName: "Gegenstand der Abgabe") {
                makeSection(number: 1) {
                    Text(
                        "Das Land erhebt eine Landschaftsabgabe für das obertägige Gewinnen mineralischer Rohstoffe in Oberösterreich."
                    )
                }

                makeSection(number: 2) {
                    Text("Von der Erhebung ausgenommen sind:")

                    makeHyphen {
                        Text("Abraummaterial,")
                    }

                    makeHyphen {
                        Text(
                            "Material aus Fließgewässern, das aus flussbaulichen Gründen wieder in Fließgewässer eingebracht wird,"
                        )
                    }

                    makeHyphen {
                        Text(
                            "bundeseigene mineralische Rohstoffe gemäß § 4 Abs. 1 Mineralrohstoffgesetz (MinroG), BGBl. I Nr. 38/1999, in der Fassung des Bundesgesetzes"
                        )
                    }

                    makeHyphen {
                        Text("Kohle,")
                    }

                    makeHyphen {
                        Text("Material aus Seitenentnahmen und")
                    }

                    makeHyphen {
                        Text(
                            "Rohstoffe, deren Verwendung Maßnahmen zur Abwehr einer unmittelbaren Gefahr für das Leben oder die Gesundheit von Menschen oder zur unmittelbaren Abwehr von Katastrophen dient."
                        )
                    }
                }

                makeSection(number: 3) {
                    Text(
                        "Die Gemeinde, in der sich eine Gewinnungsstätte befindet, erhält einen Ertragsanteil in Höhe von 20 % der Landschaftsabgabe, die im Gemeindegebiet erhoben wurde."
                    )
                }

                makeSection(number: 4) {
                    Text(
                        "Die Landschaftsabgabe ist für Angelegenheiten des Natur- und Landschaftsschutzes sowie der Landschafts- und Ortsbildpflege, zur Verbesserung der ökologischen Infrastruktur, die Umweltbildung und Umwelterziehung sowie sonstige Maßnahmen im Bereich des Umweltschutzes zu verwenden."
                    )
                }

                makeSection(number: 5) {
                    Text(
                        "Die der Gemeinde gemäß Abs. 3 zufließenden Mittel sind für Angelegenheiten des Natur- und Landschaftsschutzes sowie der Landschafts- und Ortsbildpflege, zur Verbesserung der ökologischen Infrastruktur, für naturnahe Erholungsformen in der Gemeinde, die Umweltbildung oder die Umwelterziehung zu verwenden."
                    )
                }

                makeSection(number: 6) {
                    Text(
                        "Die Überweisung des Ertragsanteils an die Gemeinden hat jeweils spätestens am 30. Juni für das vorangegangene Kalenderjahr zu erfolgen."
                    )
                }
            }

            makeParagraphWith(number: 2, andName: "Begriffsbestimmungen") {
                Text("Im Sinn des Landesgesetzes ist:")

                makeDigit(number: 1) {
                    Text(
                        "„Abraummaterial“: jedes beim Gewinnen anfallende, nicht verwertbare Material (zB taubes Gestein, Abschlämmbares) sowie Materialien, die zur Böschungsherstellung, Rekultivierung oder Geländegestaltung (zB Lärmschutz- oder Hochwasserschutzdämme) betriebsintern verwendet werden;"
                    )
                }

                makeDigit(number: 2) {
                    Text(
                        "„Betreiberin“ bzw. „Betreiber“: jede physische und juristische Person sowie jeder sonstige Rechtsträger, die bzw. der ein Gewinnen gewerblich oder berufsmäßig durchführt;"
                    )
                }

                makeDigit(number: 3) {
                    Text(
                        "„Gewinnen“: das Lösen oder Freisetzen (Abbau) mineralischer Rohstoffe einschließlich der durch dieselbe Betreiberin bzw. denselben Betreiber vorgenommenen damit zusammenhängenden vorbereitenden, begleitenden und nachfolgenden Tätigkeiten zur Aufbereitung des Naturmaterials;"
                    )
                }

                makeDigit(number: 4) {
                    Text(
                        "„Gewinnungsstätte“: Steinbruch bzw. Entnahmestelle von mineralischen Rohstoffen unabhängig davon, ob dafür eine Bewilligungspflicht nach dem MinroG besteht;"
                    )
                }

                makeDigit(number: 5) {
                    Text(
                        "„Mineralischer Rohstoff“: jedes Mineral, Mineralgemenge oder Gestein (Fest- und Lockergestein), wenn es natürlicher Herkunft ist;"
                    )
                }

                makeDigit(number: 6) {
                    Text(
                        "„Seitenentnahme“: obertägiges Gewinnen im direkten Areal eines Bauprojekts zwecks Verwendung bei diesem Bauprojekt;"
                    )
                }

                makeDigit(number: 7) {
                    Text(
                        "„Verwertung“: Übergabe an Dritte oder betriebsinterne Übergabe zur Weiterverarbeitung nach der Aufbereitung."
                    )
                }
            }

            makeParagraphWith(number: 3, andName: "Abgabepflichtige bzw. Abgabepflichtiger") {
                Text(
                    "Abgabepflichtige bzw. Abgabepflichtiger ist die Betreiberin bzw. der Betreiber einer Gewinnungsstätte eines abgabepflichtigen Materials."
                )
            }

            makeParagraphWith(number: 4, andName: "Abgabenbefreiung") {
                Text(
                    "Von der Landschaftsabgabe befreit sind Betreiberinnen bzw. Betreiber, deren Abgabenschuld im jeweiligen Kalenderjahr weniger als 120 Euro beträgt."
                )
            }

            makeParagraphWith(number: 5, andName: "Höhe der Abgabe") {
                makeSection(number: 1) {
                    Text(
                        "Die Höhe der Landschaftsabgabe beträgt 15,95 Cent pro Tonne gewonnenen und verwerteten mineralischen Rohstoffs."
                    )
                }

                makeSection(number: 2) {
                    Text(
                        "Der im Abs. 1 festgesetzte Tarif ändert sich jeweils zum 1. Jänner entsprechend den durchschnittlichen Änderungen des von der Bundesanstalt „Statistik Austria“ für das zweitvorangegangene Jahr verlautbarten Verbraucherpreisindex 2015 oder eines an seine Stelle tretenden Index. Bezugsgröße für die erstmalige Änderung zum Stichtag 1. Jänner 2025 ist der durchschnittliche Indexwert für das Jahr 2017; Bezugsgröße für jede weitere Änderung ist der durchschnittliche Indexwert des der jeweils letzten Änderung zweitvorangegangenen Kalenderjahres. Ein sich aus dieser Berechnung ergebender neuer Betrag ist auf einen vollen Hundertstel-Centbetrag zu runden, wobei Beträge bis einschließlich 0,005 Cent abgerundet und Beträge über 0,005 Cent aufgerundet werden. Eine solchermaßen ermittelte Änderung des Tarifs wird nur dann wirksam, wenn der geänderte Betrag von der Landesregierung vor dem Stichtag 1. Jänner im Landesgesetzblatt für Oberösterreich kundgemacht wurde."
                    )
                }
            }

            makeParagraphWith(number: 6, andName: "Entstehen der Abgabenschuld") {
                Text(
                    "Die Abgabenschuld entsteht zu dem Zeitpunkt, in dem das gewonnene Material verwertet wird."
                )
            }

            makeParagraphWith(number: 7, andName: "Aufzeichnungspflicht") {
                Text(
                    "Die bzw. der Abgabepflichtige ist verpflichtet, zur Feststellung der Abgabe und der Grundlagen ihrer Berechnung Aufzeichnungen zu führen."
                )
            }

            makeParagraphWith(number: 8, andName: "Anzeigepflicht") {
                Text(
                    "Die bzw. der Abgabepflichtige hat den Beginn und das Ende eines abgabepflichtigen Gewinnens binnen vier Wochen der Abgabenbehörde anzuzeigen."
                )
            }

            makeParagraphWith(number: 9, andName: "Selbstbemessung, Fälligkeit") {
                makeSection(number: 1) {
                    Text(
                        "Die bzw. der Abgabepflichtige hat die Abgabe selbst zu bemessen. Die Abgabenerklärung ist jeweils bis 30. April eines jeden Jahres (Fälligkeitstag) für die im Vorjahr entstandene Abgabenschuld einzureichen."
                    )
                }

                makeSection(number: 2) {
                    Text(
                        "Die Abgabenerklärung ist nach Gemeinden und nach Gewinnungsstätten aufzugliedern. Die bzw. der Abgabepflichtige hat den Abgabenbetrag zu berechnen und die Abgabe am Fälligkeitstag zu entrichten."
                    )
                }
            }

            makeParagraphWith(number: 10, andName: "Behörde") {
                Text("Abgabenbehörde ist die Landesregierung.")
            }

            makeParagraphWith(number: 11, andName: "Übermittlung von Daten") {
                makeSection(number: 1) {
                    Text(
                        "Die Abgabenbehörde hat jährlich jeweils bis 30. September eines jeden Jahres die ihr im Rahmen der Vorlage von Abgabenerklärungen für die im Vorjahr entstandene Abgabenschuld bekannt gegebenen"
                    )

                    makeHyphen {
                        Text(
                            "Namen oder Firmenbezeichnungen oder Firmenbuchnummern der Betreiberinnen und Betreiber von Gewinnungsstätten,"
                        )
                    }

                    makeHyphen {
                        Text("den Ort der Gewinnung (politischer Bezirk und Gemeinde) und")
                    }

                    makeHyphen {
                        Text(
                            "die Menge des dort gewonnenen und verwerteten mineralischen Rohstoffs")
                    }

                    Text(
                        "in elektronischer Form an die für die Vollziehung des Oö. Raumordnungsgesetzes 1994 (Oö. ROG 1994) zuständige Behörde und die die Parteistellung gemäß § 81 MinroG wahrnehmende Dienststelle des Amtes der Landesregierung zum Zweck der Einspeisung in das Oö. Rohstoffinformationssystem zu übermitteln."
                    )
                }

                makeSection(number: 2) {
                    Text(
                        "Sollte ein Hinderungsgrund für die vollständige oder auch nur teilweise Datenübermittlung vorliegen, hat die Abgabenbehörde die für die Vollziehung des Oö. ROG 1994 zuständige Behörde und die die Parteistellung gemäß § 81 MinroG wahrnehmende Dienststelle des Amtes der Landesregierung hierüber unter Mitteilung des Hinderungsgrundes zu informieren."
                    )
                }

                makeSection(number: 3) {
                    Text(
                        "Die Naturschutzbehörden haben in Bewilligungsbescheide gemäß § 5 Z 11 und 15 Oö. Natur- und Landschaftsschutzgesetz 2001 einen Hinweis auf die Verpflichtungen nach dem Oö. Landschaftsabgabegesetz aufzunehmen."
                    )
                }
            }

            makeParagraphWith(number: 12, andName: "Schlussbestimmungen") {
                makeSection(number: 1) {
                    Text(
                        "Dieses Landesgesetz tritt mit dem seiner Kundmachung im Landesgesetzblatt für Oberösterreich folgenden Monatsersten in Kraft."
                    )
                }

                makeSection(number: 2) {
                    Text(
                        "Personen, die zum Zeitpunkt des Inkrafttretens dieses Landesgesetzes bereits eine Gewinnungsstätte eines abgabepflichtigen Materials betreiben, haben ihre Tätigkeit binnen vier Wochen nach Inkrafttreten dieses Landesgesetzes der Abgabenbehörde anzuzeigen."
                    )
                }

                makeSection(number: 3) {
                    Text(
                        "Abweichend von § 9 ist die Abgabenerklärung für das erste Halbjahr 2018 bis längstens 31. Oktober 2018 einzureichen und auch die Abgabe für das erste Halbjahr 2018 bis längstens 31. Oktober 2018 zu entrichten."
                    )
                }
            }
        }

        let copy = landschaftsabgabegesetz
        XCTAssert(copy == landschaftsabgabegesetz)

        // Property List
        landschaftsabgabegesetz.saveToPropertyList("/tmp/test.sav")
        let loadedPropertyListAct = ActKit.Act.loadFromPropertyList("/tmp/test.sav")
        XCTAssert(landschaftsabgabegesetz == loadedPropertyListAct)

        // JSON
        landschaftsabgabegesetz.saveToJSON("/tmp/test.json")
        let loadedJSONAct = ActKit.Act.loadFromJSON("/tmp/test.json")
        XCTAssert(landschaftsabgabegesetz == loadedJSONAct)
    }

}

XCTMain([
    testCase(ActKitTests.allTests)
])
