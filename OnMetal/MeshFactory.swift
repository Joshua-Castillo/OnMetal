//
//  MeshFactory.swift
//  OnMetal
//
//  Created by Joshua Castillo on 2024-06-17.
//

import Metal

struct Mesh {
    let vertexBuffer: MTLBuffer;
    let indexBuffer: MTLBuffer;
    let indexCount: Int;
}

class MeshFactory {
    let device: MTLDevice
    
    init(device: MTLDevice) {
        self.device = device
    }
    
    func make_triangle() -> MTLBuffer {
        
        let vertices: [Vertex] = [
            Vertex(position: [-0.5, -0.5, 0.0, 1.0], color: [1,0,0]),
            Vertex(position: [0.5, -0.5, 0.0, 1.0], color: [0,1,0]),
            Vertex(position: [0.0, 0.5, 0.0, 1.0], color: [0,1,1]),
        ]
        
        return device.makeBuffer(
            bytes: vertices,
            length: vertices.count * MemoryLayout<Vertex>.stride)!
    }
    
    func make_quad() -> Mesh {
        
        let vertices: [Vertex] = [
            Vertex(position: [-0.5, -0.5, 0.0, 1.0], color: [1,1,1]),
            Vertex(position: [0.5, -0.5, 0.0, 1.0], color: [1,1,1]),
            Vertex(position: [0.5, 0.5, 0.0, 1.0], color: [1,1,1]),
            Vertex(position: [-0.5, 0.5, 0.0, 1.0], color: [0,1,1]),
        ]
        
        let indicies: [UInt16] = [
            0, 1, 2,
            2, 3, 0,
        ]
        
        let vertexBuffer = device.makeBuffer(
            bytes: vertices,
            length: vertices.count * MemoryLayout<Vertex>.stride)!
        
        let indexBuffer = device.makeBuffer(
            bytes: indicies,
            length: vertices.count * MemoryLayout<Vertex>.stride)!
        
        return Mesh(vertexBuffer: vertexBuffer, indexBuffer: indexBuffer, indexCount: 6)
    }
    
}
