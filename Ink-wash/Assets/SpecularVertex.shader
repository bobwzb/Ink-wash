// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/SpecularVertex"
{
	Properties
	{
		_Diffuse("Diffuse",Color) = (1,1,1,1)
		_Specular("Specular", Color) = (1, 1, 1, 1)
	    _Gloss("Gloss", Range(8.0, 256)) = 20

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
	    fixed4 _Specular;
		float _Gloss;
	//顶点着色器输入，顶点和法线
	struct a2v {
		//模型坐标系坐标位置
		float4 vertex : POSITION;
		float3 normal : NORMAL;
	};
	//片元着色器输入，裁剪坐标系下顶点位置和颜色
	struct v2f {
		float4 pos : SV_POSITION;
		float3 worldNormal : TEXCOORD0;
		float3 worldPos : TEXCOORD1;
	};

	//顶点着色器，输入为模型顶点和法线，输出返回v2f结构体
	v2f vert(a2v v) {
		v2f o;
		// Transform the vertex from object space to projection space
		o.pos = UnityObjectToClipPos(v.vertex);

		// Transform the normal fram object space to world space
		o.worldNormal = mul(v.normal, (float3x3)unity_WorldToObject);
		// Transform the vertex from object space to world space
		o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

		return o;
	}

	fixed4 frag(v2f i) : SV_Target{
		// Get ambient term
		fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

		fixed3 worldNormal = normalize(i.worldNormal);
		fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);

		// Compute diffuse term
		fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLightDir));

		// Get the reflect direction in world space
		fixed3 reflectDir = normalize(reflect(-worldLightDir, worldNormal));
		// Get the view direction in world space
		fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);
		// Compute specular term
		fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(reflectDir, viewDir)), _Gloss);

		return fixed4(ambient + diffuse + specular, 1.0);
	}

		ENDCG
	}
	}
		FallBack "Diffuse"
}