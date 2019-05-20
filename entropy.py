# from skimage
import numpy as np
import torch


def entropy(pk, base=None):
    """Calculate the entropy of a distribution for given probability values.

    If only probabilities `pk` are given, the entropy is calculated as
    ``S = -sum(pk * log(pk), axis=0)``.

    Parameters
    ----------
    pk : sequence
        Defines the (discrete) distribution. ``pk[i]`` is the (possibly
        unnormalized) probability of event ``i``.
    base : float, optional
        The logarithmic base to use, defaults to ``e`` (natural logarithm).

    Returns
    -------
    S : float
        The calculated entropy.

    """
    pk = pk.float() / torch.sum(pk)
    pk[pk == 0] = 1  # HACK
    vec = -pk * torch.log(pk)
    return torch.sum(vec) / np.log(base)


def shannon_entropy(image, base=2):
    """Calculate the Shannon entropy of an image.

    The Shannon entropy is defined as S = -sum(pk * log(pk)),
    where pk are frequency/probability of pixels of value k.

    Parameters
    ----------
    image : (N, M) ndarray
        Grayscale input image.
    base : float, optional
        The logarithmic base to use.

    Returns
    -------
    entropy : float

    Notes
    -----
    The returned value is measured in bits or shannon (Sh) for base=2, natural
    unit (nat) for base=np.e and hartley (Hart) for base=10.

    References
    ----------
    .. [1] https://en.wikipedia.org/wiki/Entropy_(information_theory)
    .. [2] https://en.wiktionary.org/wiki/Shannon_entropy
    """

    counts = torch.bincount(torch.round(image).long().flatten())
    return entropy(counts, base=base)
