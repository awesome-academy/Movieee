import XCTest
import Quick
import Nimble
@testable import Movieee

class MovieeeTests: QuickSpec {
    override func spec() {
        describe("People Detail View Controller") {
            var peopleDetailView: PeopleDetailViewController!
            var mirror: PeopleDetailViewMirror!
            var cellMirror: KnownForCollectionMirror!
            
            beforeEach {
                let peopleDetailStoryboard = UIStoryboard(name: IdStoryboard.peopleDetail,
                                                          bundle: nil)
                peopleDetailView = peopleDetailStoryboard.instantiateViewController(
                    withIdentifier: IdViewController.peopleDetail) as? PeopleDetailViewController
                
                peopleDetailView.personId = 90633
                peopleDetailView.loadViewIfNeeded()
                
                mirror = PeopleDetailViewMirror(peopleDetail: peopleDetailView)
                if let knownForCell = mirror.knownForCollectionView?
                    .cellForItem(at: IndexPath(row: 0, section: 0)) as? KnownForCollectionCell {
                    cellMirror = KnownForCollectionMirror(knownFor: knownForCell)
                }
            }
            
            context("check id people") {
                it("data api") {
                    APIMovie.apiMovie.getPersonDetail(personId: "\(peopleDetailView.personId)") { [weak self] result in
                        let resultInJson = self?.loadPersonDetailJson(fileName: "response")
                        expect(result).toNot(beNil())
                        expect(result).to(equal(resultInJson))
                    }
                }
            }
            
            context("birthday label") {
                it("content of label") {
                    expect(mirror.castBirthLabel?.text).toEventually(equal("1985-04-30"))
                }
            }
            
            context("biography label") {
                it("content of label") {
                    expect(mirror.castBiography?.text).toEventually(equal("Gal Gadot (born: April 30, 1985) is an Israeli actress and model. She was born in Rosh Ha'ayin, Israel, to an Ashkenazi Jewish family (from Poland, Austria, Germany, and Czechoslovakia). She served in the IDF for two years, and won the Miss Israel title in 2004.\n\nGal began modeling in the late 2000s, and made her film debut in the fourth film of the Fast and Furious franchise, Fast & Furious (2009), as Gisele, an associate of the film's lead villain. Her role was expanded in the sequels Fast Five (2011) and Fast & Furious 6 (2013), in which her character was romantically linked to Han Seoul-Oh (Sung Kang). In the films, Gal performed her own stunts. She also appeared in the 2010 films Date Night (2010) and Knight and Day (2010). In early December 2013, Gal was cast as Wonder Woman in the DC Extended Universe.\n\nGal is a motorcycle enthusiast, and owns a black 2006 Ducati Monster-S2R. She has been married to Yaron Versano since September 28, 2008. They have one child."))
                }
            }
            
            context("people name label") {
                it("content of label") {
                    expect(mirror.castNameLabel?.text).toEventually(equal("Gal Gadot"))
                }
            }
            
            context("department name label") {
                it("content of label") {
                    expect(mirror.castDepartmentLabel?.text).toEventually(equal("Acting"))
                }
            }
            
            context("gender kind label") {
                it("content of label") {
                    expect(mirror.castGenderLabel?.text).toEventually(equal("Female"))
                }
            }
            
            context("content known for cell ") {
                it("first cell") {
                    if let cellMirror = cellMirror {
                        expect(cellMirror.movieNameLabel?.text).toEventually(equal("Wonder Woman 1984"))
                    }
                }
            }
        }
    }
    
    func loadPersonDetailJson(fileName: String) -> PersonDetail? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(PersonDetail.self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
}
