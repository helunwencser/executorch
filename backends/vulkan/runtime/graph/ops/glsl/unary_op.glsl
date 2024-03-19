/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#version 450 core

#define PRECISION ${PRECISION}

#define OP(X, A, B) ${OPERATOR}

layout(std430) buffer;

layout(set = 0, binding = 0, ${IMAGE_FORMAT[DTYPE]}) uniform PRECISION restrict writeonly ${IMAGE_T[NDIM][DTYPE]} image_out;
layout(set = 0, binding = 1) uniform PRECISION sampler3D image_in;

layout(set = 0, binding = 2) uniform PRECISION restrict OutSizes {
  ivec4 data;
}
out_sizes;

layout(set = 0, binding = 3) uniform PRECISION restrict Min {
  float data;
}
minimum;

layout(set = 0, binding = 4) uniform PRECISION restrict Max {
  float data;
}
maximum;

layout(local_size_x_id = 0, local_size_y_id = 1, local_size_z_id = 2) in;

void main() {
  const ivec3 pos = ivec3(gl_GlobalInvocationID);

  vec4 in_texel = texelFetch(image_in, pos, 0);
  imageStore(image_out, pos, OP(in_texel, minimum.data, maximum.data));
}
