import struct MVNetwork.MovieDTO

struct Movie: Equatable, Identifiable {
    
    let id: Int
    
    init(dto: MovieDTO) {
        self.id = dto.id
    }
}
