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

struct VSOut {
    float4 pos [[position]];
};

vertex RastData vertex_main(
                        const device UVVertex* vertices [[buffer(0)]],
                        unsigned int vertexId [[vertex_id]],
                        constant FrameUniforms &u [[buffer(11)]]
                        ) {
    UVVertex v = vertices[vertexId];
    float4 transformed = u.transform * float4(v.position, 1, 1);

    RastData out {
        .pos = transformed,
        .uv = v.uv
    };

    return out;
}

vertex RastData vertex_death_flash(
                                 const device Vertex* vertices [[buffer(0)]],
                                 unsigned int vertexId [[vertex_id]]
                                 ) {
    Vertex v = vertices[vertexId];

    RastData out = {
        .pos = float4(v.position, 1, 1),
        .uv = v.position
    };
    
    return out;
}

