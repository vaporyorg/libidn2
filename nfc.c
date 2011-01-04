/*
 * nfc.c - Unicode NFC
 * Copyright (C) 2011 Simon Josefsson
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public License
 * as published by the Free Software Foundation; either version 2.1 of
 * the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
 * 02110-1301 USA
 *
 */

#include "libidna.h"

#include <errno.h>

#include "uninorm.h"

int
libidna_nfc_u8 (const uint8_t *src, size_t srclen,
		uint8_t *dst, size_t *dstlen)
{
  uint8_t *p = u8_normalize (UNINORM_NFC, src, srclen, dst, dstlen);
  if (p == NULL)
    {
      printf ("failed %d\n", errno);
      return LIBIDNA_NFC_FAIL;
    }
  *dst = p;
  return LIBIDNA_OK;
}