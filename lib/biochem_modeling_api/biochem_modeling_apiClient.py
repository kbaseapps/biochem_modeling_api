# -*- coding: utf-8 -*-
############################################################
#
# Autogenerated by the KBase type compiler -
# any changes made here will be overwritten
#
############################################################

from __future__ import print_function
# the following is a hack to get the baseclient to import whether we're in a
# package or not. This makes pep8 unhappy hence the annotations.
try:
    # baseclient and this client are in a package
    from .baseclient import BaseClient as _BaseClient  # @UnusedImport
except:
    # no they aren't
    from baseclient import BaseClient as _BaseClient  # @Reimport


class biochem_modeling_api(object):

    def __init__(
            self, url=None, timeout=30 * 60, user_id=None,
            password=None, token=None, ignore_authrc=False,
            trust_all_ssl_certificates=False,
            auth_svc='https://kbase.us/services/authorization/Sessions/Login'):
        if url is None:
            raise ValueError('A url is required')
        self._service_ver = None
        self._client = _BaseClient(
            url, timeout=timeout, user_id=user_id, password=password,
            token=token, ignore_authrc=ignore_authrc,
            trust_all_ssl_certificates=trust_all_ssl_certificates,
            auth_svc=auth_svc)

    def search_reaction(self, params, context=None):
        """
        :param params: instance of type "DropDownItemInputParams" ->
           structure: parameter "search" of String, parameter "limit" of
           Long, parameter "start" of Long
        :returns: instance of type "DropDownDataRxn" -> structure: parameter
           "num_of_hits" of Long, parameter "hits" of list of type
           "DropDownItemRxn" -> structure: parameter "id" of String,
           parameter "name" of String, parameter "equation" of String,
           parameter "code" of String, parameter "definition" of String,
           parameter "searchnames" of String
        """
        return self._client.call_method(
            'biochem_modeling_api.search_reaction',
            [params], self._service_ver, context)

    def search_compound(self, params, context=None):
        """
        :param params: instance of type "DropDownItemInputParams" ->
           structure: parameter "search" of String, parameter "limit" of
           Long, parameter "start" of Long
        :returns: instance of type "DropDownDataCpd" -> structure: parameter
           "num_of_hits" of Long, parameter "hits" of list of type
           "DropDownItemCpd" -> structure: parameter "id" of String,
           parameter "name" of String, parameter "formula" of String,
           parameter "abr" of String, parameter "searchnames" of String
        """
        return self._client.call_method(
            'biochem_modeling_api.search_compound',
            [params], self._service_ver, context)

    def status(self, context=None):
        return self._client.call_method('biochem_modeling_api.status',
                                        [], self._service_ver, context)
