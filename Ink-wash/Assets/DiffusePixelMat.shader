// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/DiffusePixelMat"
{
	Properties
	{
		_Diffuse("Diffuse",Color) = (1,1,1,1)
	}
		SubShader
	{
		Pass
		{
		//在Pass第一行指定渲染光照模式
		Tags{"Lightmode" = "ForwardBase"}
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		//引用Unity内置文件，需要用到一些内置变量
		#include "UnityCG.cginc"
		#include "Lighting.cginc" 
		//定义与Properties中匹配的变量
		fixed4 _Diffuse;
	//顶点着色器输入，顶点和法线
	struct a2v {
		//模型坐标系坐标位置
		float4 vertex : POSITION;
		float3 normal : NORMAL;
	};
	//片元着色器输入，裁剪坐标系下顶点位置和颜色
	struct v2f {
		//裁剪坐标系顶点位置
		float4 pos : SV_POSITION;
		float3 worldNormal : TEXCOORD0;
	};
	//顶点着色器，输入为模型顶点和法线，输出返回v2f结构体
	v2f vert(a2v v) {
		v2f o;
		// Transform the vertex from object space to projection space
		o.pos = UnityObjectToClipPos(v.vertex);

		// Transform the normal fram object space to world space
		o.worldNormal = mul(v.normal, (float3x3)unity_WorldToObject);

		return o;
	}
	//片元着色器，输入为顶点着色器输出值
	fixed4 frag(v2f i) :SV_Target{
		// Get ambient term
	fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

	// Get the normal in world space
	fixed3 worldNormal = normalize(i.worldNormal);
	// Get the light direction in world space
	fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);

	// Compute diffuse term
	fixed halfLambert = dot(worldNormal, worldLightDir) * 0.5 + 0.2;
	fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * halfLambert;

	fixed3 color = ambient + diffuse;

	return fixed4(color, 1.0);
	}
	ENDCG
}
	}
		FallBack "Diffuse"
}
