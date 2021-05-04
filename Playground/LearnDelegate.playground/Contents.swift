struct Cookie {
    var size: Int = 5
    var hasChocolateChips: Bool = false
}

protocol BakeryDelegate {
    func cookieWasBaked(_ cookie: Cookie)
}

protocol BakeryRequestDelegate {
    func makeCookie()
}

class Bakery : BakeryRequestDelegate {
    var delegate: BakeryDelegate?
    
    func makeCookie() {
        let cookie = Cookie(size: 5, hasChocolateChips: true)
        print(cookie.size)
        delegate?.cookieWasBaked(cookie)
    }

}

class Deliver: BakeryDelegate {
    var delegate: BakeryRequestDelegate?
    
    func getCookie() {
        delegate?.makeCookie()
    }
    func cookieWasBaked(_ cookie: Cookie) {
        print(cookie.hasChocolateChips)
    }
}

var deliver = Deliver()
var bakery = Bakery()

deliver.delegate = bakery
bakery.delegate = deliver

deliver.getCookie()

