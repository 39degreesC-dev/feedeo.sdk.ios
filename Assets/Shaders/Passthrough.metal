/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Pass-through shader (used for preview).
*/

#include <metal_stdlib>
using namespace metal;

// Vertex input/output structure for passing results from vertex shader to fragment shader
struct VertexIO
{
    float4 position [[position]];
    float2 textureCoord [[user(texturecoord)]];
};

struct Uniform {
    float4x4 modelMatrix;
};


// Vertex shader for a textured quad
vertex VertexIO vertexPassThrough(const device packed_float2 *pPosition  [[ buffer(0) ]],
                                  const device packed_float2 *pTexCoords [[ buffer(1) ]],
                                  constant Uniform &uniform [[buffer(2)]],
                                  uint                  vid        [[ vertex_id ]])
{
    VertexIO outVertex;

    float4 newPos = uniform.modelMatrix * float4(pPosition[vid], 0, 1.0);
    outVertex.position = newPos;
    outVertex.textureCoord = pTexCoords[vid];

    return outVertex;
}

// Fragment shader for a textured quad
fragment half4 fragmentPassThrough(VertexIO fragmentInput [[stage_in]],
                                   texture2d<half> inputTexture [[texture(0)]])
{
    constexpr sampler quadSampler;
    half4 color = inputTexture.sample(quadSampler, fragmentInput.textureCoord);

    return color;
}
