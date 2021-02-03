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
                it("content of label") { [weak self] in
                    let resultInJson = self?.loadPersonDetailJson(fileName: "response")
                    expect(mirror.castBiography?.text).toEventually(equal(resultInJson?.biography))
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
