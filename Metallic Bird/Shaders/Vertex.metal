//
//  Vertex.metal
//  Metallic Bird
//
//  Created by Alex Sigalos on 10/19/25.
//

#include <metal_stdlib>
#include "Common.h"
#include "ShaderStructs.metal"
using namespace metal;

//struct VSIn {
//    float2 corner [[attribute(0)]];   // unit quad corners (-0.5..0.5)
//};
//
struct VSOut {
    float4 pos [[position]];
};

vertex RastData vertex_main(
                        const device Vertex* vertices [[buffer(0)]],
                        unsigned int vertexId [[vertex_id]],
                        constant FrameUniforms &u [[buffer(11)]]
                        ) {
    Vertex v = vertices[vertexId];
    float4 transformed = u.transform * float4(v.position, 1, 1);

    RastData out {
        .pos = transformed,
        .uv = v.uv
    };

    return out;
}
//vertex RastData vertex_main(
//                            const device Vertex* vertices [[buffer(0)]],
//                            unsigned int vertexId [[vertex_id]],
//                            constant FrameUniforms &u [[buffer(11)]]
//                            ) {
//    Vertex in = vertices[vertexId];
//    float4 transformed = u.transform * float4(in.position, 1, 1);
//
//    RastData out {
//        .pos = transformed,
//        .uv = in.uv
//    };
//
//    return out;
//}
