//
//  Renderer.swift
//  OnMetal
//
//  Created by Joshua Castillo on 2024-06-17.
//

import MetalKit

class Renderer: NSObject, MTKViewDelegate {
    
    var parent: ContentView
    var device: MTLDevice!
    var commandQueue: MTLCommandQueue!
    var pipeline: MTLRenderPipelineState
    let triangle: MTLBuffer
    let quad: Mesh
    
    init(_ parent: ContentView){
        self.parent = parent
        
        if let device = MTLCreateSystemDefaultDevice() {
            self.device = device
        }
        
        self.commandQueue = device.makeCommandQueue()
        
        pipeline = build_pipeline(device: device)
        
        let meshFactory = MeshFactory(device: device)
        triangle = meshFactory.make_triangle()
        quad = meshFactory.make_quad()
        
        super.init()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable else {
            return
        }
        let commandBuffer = commandQueue.makeCommandBuffer()!
        
        let renderPassDescriptor = view.currentRenderPassDescriptor!
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.0, 0.5, 0.5, 1.0)
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].storeAction = .store
        
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        
        renderEncoder.setRenderPipelineState(pipeline)
        
        renderEncoder.setVertexBuffer(
            quad.vertexBuffer,
            offset: 0,
            index: 0
        )
        
        renderEncoder.drawIndexedPrimitives(
            type: .triangle,
            indexCount: 6,
            indexType: .uint16,
            indexBuffer: quad.indexBuffer,
            indexBufferOffset: 0
        )
        
        renderEncoder.setVertexBuffer(
            triangle,
            offset: 0,
            index: 0
        )
        
        renderEncoder.drawPrimitives(
            type: .triangle,
            vertexStart: 0,
            vertexCount: 3
        )
        
        renderEncoder.endEncoding()
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
