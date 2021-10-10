import Swifter
import Foundation
import Network

class Server {

    func run() -> String {
        let server = HttpServer()
        var address = "error"
        server["/"] = scopes {
          html {
            body {
                h1 {
                    inner = "FastTransfer server is working"
                }
            }
          }
        }
        do {
            try server.start()
            let strIPAddress = self.getIPAddress()
            address = "http://\(strIPAddress):\(try server.port())"
            print("FastTransfer server started on \(address)")
        } catch {
            print("Error info: \(error)")
        }

        return address
    }

    func getDownloadsDirectory() -> String {
        let paths = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory.absoluteString
    }

    func getIPAddress() -> String {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }

                guard let interface = ptr?.pointee else { return "" }
                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

                    // wifi = ["en0"]
                    // wired = ["en2", "en3", "en4"]
                    // cellular = ["pdp_ip0","pdp_ip1","pdp_ip2","pdp_ip3"]

                    let name: String = String(cString: (interface.ifa_name))
                    if  name == "en0" || name == "en2" || name == "en3" || name == "en4" || name == "pdp_ip0" || name == "pdp_ip1" || name == "pdp_ip2" || name == "pdp_ip3" {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface.ifa_addr, socklen_t((interface.ifa_addr.pointee.sa_len)), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return address ?? ""
    }
}
