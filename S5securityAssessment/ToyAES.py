from wboxkit.ciphers.aes.sbox import bSbox, bitSbox

#A toy AES working on one input Byte with a one Byte key, enough to be attacked
def ToyAES(plaintext, key):

    S1 = [None] * 8

    #AddRoundKey
    S1[0] = plaintext[0] ^ key[0]
    S1[1] = plaintext[1] ^ key[1]
    S1[2] = plaintext[2] ^ key[2]
    S1[3] = plaintext[3] ^ key[3]
    S1[4] = plaintext[4] ^ key[4]
    S1[5] = plaintext[5] ^ key[5]
    S1[6] = plaintext[6] ^ key[6]
    S1[7] = plaintext[7] ^ key[7]

    #SubBytes
    S2 = bitSbox(S1, inverse=0)

    ciphertext = bitSbox(S2, inverse=0)

    return ciphertext
