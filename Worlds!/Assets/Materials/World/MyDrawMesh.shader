﻿Shader "Materials/World/MyDrawMesh"
{
    SubShader
    {
		Cull back
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

			struct Vertex
			{
				float4 position;
				float3 normal;
			};

			uniform StructuredBuffer<Vertex> _MeshBuffer;
			uniform float4x4 _ObjectToWorld;
			uniform float4 _Offset;
			uniform float _Scale;
			uniform int _Lod;

            struct v2f
            {
				float4 vertex : SV_POSITION;
				float3 color : COLOR;
                
            };

            v2f vert (uint id : SV_VertexID)
            {
				v2f o;
				float4 worldPos = mul(_ObjectToWorld, float4(_MeshBuffer[id].position.xyz, 1.0f) - _Offset * _Scale);
                o.vertex = UnityObjectToClipPos(worldPos);
				//o.color = dot(float3(0, 1, 0), _MeshBuffer[id].normal) * 0.5 + 0.5;
				if (_Lod == 1) o.color = float3(1, 0, 0);
				else if (_Lod == 2) o.color = float3(0, 1, 0);
				else if (_Lod == 4) o.color = float3(0, 0, 1);
				else o.color = dot(float3(0, 1, 0), _MeshBuffer[id].normal) * 0.5 + 0.5;
                return o;
            }

			fixed4 frag(v2f i) : SV_Target
			{
				return float4(i.color, 1.0f);
            }
            ENDCG
        }
    }
}
