//
//  Fragment.metal
//  Metallic Bird
//
//  Created by Alex Sigalos on 10/19/25.
//

#include <metal_stdlib>
#include "Common.h"
#include "ShaderStructs.metal"
using namespace metal;

fragment float4 fragment_main
(
 RastData in [[stage_in]],
 texture2d<float> texture [[texture(0)]]
 ) {
    constexpr sampler textureSampler(filter::nearest, address::repeat, mip_filter::nearest, max_anisotropy(8));
    float4 color = texture.sample(textureSampler, in.uv);
    return color;
}

fragment float4 fragment_death_flash
(
 RastData in [[stage_in]],
 constant float &opacity [[buffer(11)]]
 ) {
    return float4(1, 1, 1, opacity);
}
